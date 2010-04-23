class CreateFragments < ActiveRecord::Migration
  def self.up
    create_table :fragments do |t|
      t.string :sentence_id
      t.integer :start
      t.integer :end
      t.string :audio_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fragments
  end
end
