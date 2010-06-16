require 'joint'
class Asset
  include MongoMapper::Document
  plugin Joint
  attachment :file

  key :unit_id, ObjectId, :index => true, :required => true
  many :words, :foreign_key => 'fragment.asset_id'
  many :sentences, :foreign_key => 'fragment.asset_id'
  belongs_to :unit

  def fragments 
    [words.map do |w|
      { :content => w.content, :start => w.fragment.start, :end => w.fragment.stop }
    end,
    sentences.map do |s|
      { :content => s.content, :start => s.fragment.start, :end => s.fragment.stop }
    end].flatten.sort_by { |p| p[:start] }
  end
end
