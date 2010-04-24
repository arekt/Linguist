class Word
  include MongoMapper::Document
  key :content, String, :required => true, :index => true
  key :lang, String
  key :category, String
  key :source_id, ObjectId
  timestamps!

  many :translations
  belongs_to :source
  def fragment_audio
    audio = Audio.first(:source_id => self.source_id)
    fragment = audio.fragments.detect {|f| f.word_id == self.id } if audio
    return [fragment, audio]
  end
end
