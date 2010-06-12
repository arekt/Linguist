class Exercise 
  include MongoMapper::Document
  key :unit_id, ObjectId, :required => true, :index => true
  key :example, String
  many :questions
  belongs_to :unit
end
