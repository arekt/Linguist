class Word
  include MongoMapper::Document
  key :content, String, :required => true, :index => true
  key :lang, String
  key :category, String
  key :unit_id, ObjectId
  
  timestamps!

  one :audio_fragment
  many :translations
  belongs_to :unit
end
