require 'paperclip'
class User < ApplicationRecord
  extend Devise::Models
  has_one_attached :profile
  has_many :posts, foreign_key: 'create_user_id'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: {message: "Name can't be blank."} 
  validates :email, presence: {message: "Email can't be blank."}
  validates :password, presence: { message: "Password can't be blank." }
  validates :password_confirmation, presence: { message: "Password confirmation can't be blank." }
  validates_confirmation_of :password, message: "Password and password confirmation do not match"
  validates :profile, presence: {message: "Profile can't be blank."}

  # email format
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Invalid email format" }

  # enum utype: [:user, :moderator, :addevise :database_authenticatable, :registerable,
        

  # after_initialize :set_default_utype, :if => :new_record?
  # def set_default_utype
  #   self.utype ||= :user
  # end
  # enum utype: [:admin, :user]
  # after_initialize :set_default_role, :if => :new_record?
  # def set_default_role
  #   self.utype ||= :user
  # end

  
end


