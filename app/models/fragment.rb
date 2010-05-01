class Fragment
  include MongoMapper::EmbeddedDocument
  key :start, Integer
  key :stop,  Integer
  key :asset_id, ObjectId
  
  def asset
    Asset.find(@asset_id)
  end
  
  def asset=(asset)
    if asset
      @asset_id = asset.id 
    else
      @asset_id = nil
    end
  end
end
