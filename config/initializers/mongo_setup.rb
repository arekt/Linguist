  MongoMapper.connection = Mongo::Connection.new(ENV['DB_HOST']||"localhost")
  MongoMapper.database = "linguist2_#{RAILS_ENV}"
  MongoMapper.database.authenticate(ENV['DB_USER'], ENV['DB_PASS']) if ENV['DB_USER']
