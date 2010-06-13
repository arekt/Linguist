class Question 
  include MongoMapper::EmbeddedDocument
    key :content, String, :required => true
    many :answers
end
