# require 'paperclip'
class User < ApplicationRecord
  extend Devise::Models
  # has_attached_file :profile, styles: { medium: "300x300>", thumb: "100x100>" }
  has_attached_file :profile
  validates_attachment_content_type :profile, content_type: /\Aimage\/.*\z/
  has_many :posts, foreign_key: 'create_user_id'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  # for profile upload 
  mount_uploader :profile, ProfileUploader
  
  validates :name, presence: {message: "Name can't be blank."} 
  validates :email, presence: {message: "Email can't be blank."}
  validates :password, presence: { message: "Password can't be blank." }
  validates :password_confirmation, presence: { message: "Password confirmation can't be blank." }
  validates_confirmation_of :password, message: "Password and password confirmation do not match."
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


  def updating?
    self.persisted? && self.changed?
  end

 

  
end


