class Source
  include MongoMapper::Document
    key :name, String, :index => true, :required => true
    key :unit, String, :index => true
    key :section, String, :index => true
    key :properties, Hash
    key :elements, Array 
    many :sentences

  def display_name
    name+" "+unit+" "+section   
  end

    has_many :words
    has_many :sentences
    has_many :audios
end
