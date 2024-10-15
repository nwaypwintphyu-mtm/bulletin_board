class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :title, limit: 255, null: false
      t.string :description, null: false
      t.integer :status, null: false, default: 1
      t.integer :create_user_id 
      t.integer :updated_user_id
      t.integer :deleted_user_id
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
