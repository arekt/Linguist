require 'joint'
class Asset
  include MongoMapper::Document
  plugin Joint
  attachment :file

  key :unit_id, ObjectId, :index => true, :required => true

  belongs_to :unit
end
