class KnowledgeTest
  include MongoMapper::Document

  key :title, String, :required => true

  many :questions
  timestamps!
  userstamps!
end
