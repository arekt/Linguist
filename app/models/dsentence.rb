class Dsentence 
  include MongoMapper::EmbeddedDocument

  key :content, String
  key :person, String
  key :no, Integer
  
end
