class CreateAudioFragments < ActiveRecord::Migration
  def self.up
    create_table :audio_fragments do |t|
      t.integer :start
      t.integer :stop

      t.timestamps
    end
  end

  def self.down
    drop_table :audio_fragments
  end
end
