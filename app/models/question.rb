class Question 
  include MongoMapper::EmbeddedDocument
    key :content, String, :required => true
    key :correct_answer, String
end
