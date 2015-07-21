class User < ActiveRecord::Base
  
  # Use attr_accessor keyword to create an attribute that is not corresponding to any column in database.
  # The password attribute will not ever be written to the database, but will exist only in memory for use in performing the password confirmation step and the encryption step. 
  attr_accessor :password

  # Regex pattern for email
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Validation for name
  validates :name, presence: true,
                   length: { maximum: 50 }
  # Validation for email                 
  validates :email, presence: true,
                    format: { with: email_regex },
                    uniqueness: true
  #validation for password
  validates :password, presence: true,
                       confirmation: true,
                       length: { within: 6..40 }
                       
  validates :password_confirmation, presence: true

  before_save :encrypt_password
  
  has_many :microposts
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email email
    return nil if user.nil?
    return user if user.has_password? submitted_password
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id id
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  private
  
  def encrypt_password    
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)   
  end
  
  def encrypt(string)
    secure_hash "#{salt}--#{salt}"
  end
  
  def make_salt
    secure_hash "#{Time.now.utc}--#{password}"
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest string
  end
  
end
