class Question 
  include MongoMapper::EmbeddedDocument
    key :content, String, :required => true
    key :correct_answer, ObjectId

    one :sentence, :in => :correct_answer
end
