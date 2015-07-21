class User < ActiveRecord::Base
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, presence: true,
                   lenght: { maximum: 50 }
  validates :email, presence: true,
                    format: { with: email_regex },
                    uniqueness: true
end
