class AddProfileAttributesToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :profile_file_size, :integer
    add_column :users, :profile_updated_at, :datetime
    add_column :users, :profile_file_name, :string
  end
end
