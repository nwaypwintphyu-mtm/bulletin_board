class Post < ApplicationRecord
    validates :title, presence: {message: "Title can't be blank."},
                      length: { maximum: 255, message: "255 characters is the maximum allowed."}
    validates :description, presence: {message: "Description can't be blank."}   
    belongs_to :user, foreign_key: :create_user_id
end
