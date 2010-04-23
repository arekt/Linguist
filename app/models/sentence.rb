class Sentence 
  include MongoMapper::Document
    key :content, String, :index => true, :required => true
    key :source_id, ObjectId
    timestamps!
  
  belongs_to :source
  many  :fragments
  many  :translations

  def self.per_page; 1 end

  def content_short
    #this allow regexp on unicode strings
    $KCODE = 'u'
    re = /^.{20}/
    return re.match(content) || content
  end

  def translation_attributes=(attributes)
    translations.clear
    attributes.each do |translation|
      if !translation['content'].empty?
        translations << Translation.new(translation)
      end
    end
    Rails.logger.debug "*** translation _attributes= : #{translations.inspect}"
  end

  def fragment_audio
    audio = Audio.first(:source_id => self.source_id)
    fragment = audio.fragments.detect {|f| f.sentence_id == self.id } if audio
    return [fragment, audio]
  end

  def previous(user)
    @sentences = @sentences || Sentence.sentences(user)
    index = @sentences.find_index { |i| i == self}
    return @sentences[index-1] if index && index > 0
    return nil
  end
 
  def next(user)
    @sentences = @sentences || Sentence.sentences(user)
    index = @sentences.find_index { |i| i == self}
    return @sentences[index+1] if index && index < @sentences.length
    return nil
  end
  
  def self.sentences(user)
    return [] unless user
    sr = SearchResult.first(:user_id => user.id,:search_type=>:sentences)
    return @sentences = all(:id.in => sr.result)
  end
end
