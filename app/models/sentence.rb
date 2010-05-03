class Sentence 
  include MongoMapper::Document
  key :content, String, :required => true, :index => true
  key :lang, String
  key :category, String
  key :unit_id, ObjectId, :index => true
  key :fragment, Fragment
  timestamps!

  many :translations
  belongs_to :unit
  #one :fragment            #TODO: check if I can use key :fragment, Fragment  (I saw somewhere this) 

  def self.per_page; 10 end

  def content_short
    #this allow regexp on unicode strings
    $KCODE = 'u'
    re = /^.{20}/
    return re.match(content) || content
  end

end
