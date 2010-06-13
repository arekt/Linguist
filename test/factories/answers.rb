Factory.define :answer do |answer|
  answer.content { 'string' }

  answer.created_at { Time.now.to_s(:db) }
  answer.updated_at { Time.now.to_s(:db) }
end
