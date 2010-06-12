class CreateKnowledgeTests < ActiveRecord::Migration
  def self.up
    create_table :knowledge_tests do |t|
      t.string :title
      t.timestamps
    end
  end
  
  def self.down
    drop_table :knowledge_tests
  end
end
