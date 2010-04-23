class Adjective 
  include MongoMapper::Document
    key :content, :index => true, :required => true
    key :itype, Boolean, :required => true
    timestamps!

    many :translations
end
