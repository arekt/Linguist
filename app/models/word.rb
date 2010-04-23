class Word
  include MongoMapper::Document
  key :content, String, :required => true, :index => true
  key :lang, String
  key :category, String
  key :source_id, ObjectId
  timestamps!

  many :translations
  belongs_to :source
  def self.words(user)
    return [] unless user
    sr = SearchResult.first(:user_id => user.id,:search_type=>:words)
    return @words = all(:id.in => sr.result)
  end
  def fragment_audio
    audio = Audio.first(:source_id => self.source_id)
    fragment = audio.fragments.detect {|f| f.word_id == self.id } if audio
    return [fragment, audio]
  end
  def previous(user)
    #Word.last(:id.lt => self.id,:order=>'id DESC') //doesn't work
    @words = @words || Word.words(user)
    index = @words.find_index { |i| i == self} 
    return @words[index-1] if index > 0
    return nil
  end
  
  def next(user)
    #Word.first(:id.gt => self.id,:order =>'id ASC')
    @words = @words || Word.words(user)
    index = @words.find_index { |i| i == self}
    return @words[index+1] if index < @words.length
    return nil
  end
end
