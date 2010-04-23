class Exercise 
  include MongoMapper::Document
  key :source_id, ObjectId, :required => true, :index => true
  key :example, String

  many :questions
  belongs_to :source
end
