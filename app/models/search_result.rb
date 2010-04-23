class SearchResult
  include MongoMapper::Document
  key :user_id, Integer, :required => true, :index => true
  key :search_type, String
  key :result, Array
end
