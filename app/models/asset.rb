require 'joint'
class Asset
  include MongoMapper::Document
  plugin Joint

  attachment :file
end
