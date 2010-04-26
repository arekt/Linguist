class Unit 
  include MongoMapper::Document
  key :name, String

  many :assets 
end
