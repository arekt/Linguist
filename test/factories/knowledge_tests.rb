Factory.define :knowledge_test do |knowledge_test|

  knowledge_test.created_at { Time.now.to_s(:db) }
  knowledge_test.updated_at { Time.now.to_s(:db) }
end
