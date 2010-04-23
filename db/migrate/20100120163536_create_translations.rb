class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.String :lang
      t.String :content
      t.timestamps
    end
  end
  
  def self.down
    drop_table :translations
  end
end
