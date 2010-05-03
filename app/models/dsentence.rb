class Dsentence 
  include MongoMapper::EmbeddedDocument

  key :sentence_id, ObjectId
  key :person, String
  key :position, Integer

  belongs_to :sentence
end
