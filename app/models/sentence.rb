class Sentence 
  include MongoMapper::Document
  key :content, String, :required => true, :index => true
  key :lang, String
  key :category, String
  key :unit_id, ObjectId, :index => true
  timestamps!

  many :translations
  belongs_to :unit
  one :fragment 

  def self.per_page; 10 end

  def content_short
    #this allow regexp on unicode strings
    $KCODE = 'u'
    re = /^.{20}/
    return re.match(content) || content
  end

end
