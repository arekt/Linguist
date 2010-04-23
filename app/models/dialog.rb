class Dialog 
    include MongoMapper::Document
    key :source_id, ObjectId, :index => true
    key :title, String, :index => true, :required => true

    many :dsentences
    belongs_to :source
end
