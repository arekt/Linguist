class User
  include MongoMapper::Document
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
#  devise :registerable, :authenticatable, :recoverable,
#         :rememberable, :trackable, :validatable
 
  devise :database_authenticatable, :recoverable, :rememberable 
 
 
  key :email,  String
  key :username,  String
  key :comment_count, Integer
  key :encrypted_password, String
  key :password_salt, String
  key :reset_password_token, String
  key :remember_token, String
  key :remember_created_at, Time
  key :sign_in_count, Integer
  key :current_sign_in_at, Time
  key :current_sign_in_ip, String  
  timestamps!


  RegEmailName   = '[\w\.%\+\-]+'
  RegDomainHead  = '(?:[A-Z0-9\-]+\.)+'
  RegDomainTLD   = '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RegEmailOk     = /\A#{RegEmailName}@#{RegDomainHead}#{RegDomainTLD}\z/i
  
  validates_length_of :email, :within => 6..100, :allow_blank => true
  validates_format_of :email, :with => RegEmailOk, :allow_blank => true

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation
 # def self.attr_accessible (*accessible_attributes)
 #   protected_attributes = accessible_attributes
 #   accessible_attributes.each do |accesible_attr|
 #     protected_attributes.delete_if{|k,v| k.to_s == accesible_attr}
 #   end
 #   attr_protected protected_attributes
 # end
 # 
 # attr_accessible :email
end
