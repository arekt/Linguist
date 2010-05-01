class Unit 
  include MongoMapper::Document
  key :name, String

  many :assets 
  many :words do
    def without_asset
      #if fragment don't exist
      #or fragment.asset_id is nil
      self.select do |w| w.fragment == nil || w.fragment.asset_id == nil end
    end
  end

end
