class AudioFragment 
include MongoMapper::EmbeddedDocument
  key :start, Integer
  key :stop, Integer
  
  has_one :asset
end
