class Fragment
  include MongoMapper::EmbeddedDocument

  key :sentence_id, ObjectId
  key :word_id, ObjectId
  key :start, Integer
  key :end, Integer
  
  belongs_to :sentence
  belongs_to :word
end
