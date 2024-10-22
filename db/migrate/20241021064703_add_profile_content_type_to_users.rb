class AddProfileContentTypeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :profile_content_type, :string
 end
end
