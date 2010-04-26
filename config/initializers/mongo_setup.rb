
  MongoMapper.connection = Mongo::Connection.new('localhost')
  MongoMapper.database = "linguist2_#{RAILS_ENV}"

