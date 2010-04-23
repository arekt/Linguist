class Audio
  include MongoMapper::Document
  key :filename, String
  key :source_id, ObjectId
  key :waveform, String
  timestamps!

  belongs_to :source
  many :fragments
end
