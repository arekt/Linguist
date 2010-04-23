class Question 
  include MongoMapper::EmbeddedDocument
    key :content, :index => true, :required => true
    key :correct_answer, String
end
