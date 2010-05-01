require 'joint'
class Asset
  include MongoMapper::Document
  plugin Joint
  attachment :file

  #key :word_ids, Array
  key :unit_id, ObjectId, :index => true, :required => true
  belongs_to :unit
  #many :words
end
