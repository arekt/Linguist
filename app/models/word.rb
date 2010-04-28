class Word
  include MongoMapper::Document
  key :content, String, :required => true, :index => true
  key :lang, String
  key :category, String
  key :unit_id, ObjectId
  timestamps!

  many :translations
  belongs_to :unit
end
