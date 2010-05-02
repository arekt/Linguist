require 'joint'
class Asset
  include MongoMapper::Document
  plugin Joint
  attachment :file

  key :unit_id, ObjectId, :index => true, :required => true
  many :words, :foreign_key => 'fragment.asset_id'
  belongs_to :unit
end
