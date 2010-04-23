  MongoMapper.connection = Mongo::Connection.new('localhost')
  MongoMapper.database = "linguist_#{RAILS_ENV}"

