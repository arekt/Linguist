class Dialog 
    include MongoMapper::Document
    key :unit_id, ObjectId, :index => true
    key :title, String, :index => true, :required => true

    many :dsentences do
      def sorted
        self.collect.sort_by { |s| s.position }
      end
    end
    belongs_to :unit
end
