class Property
  def initialize(hash)
    hash.keys.each do |key|
      self.class.send :attr_accessor, key.to_sym
      self.instance_variable_set('@'+key.to_s, hash[key])
    end  
  end

  def new_record?
    true
  end
end
