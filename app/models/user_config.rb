class UserConfig
  include MongoMapper::Document
  key :user_id, Integer, :index => true, :required => true
  key :config, Hash

  belongs_to :user
end
