# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.timestamps null: false

      t.string :name #  null: false 
      # t.string :email, null: false 
      # t.text :password, null: false
      # t.string :profile, limit: 255 #null: false
      t.string :profile #null: false
      t.integer :utype, default: 1
      t.string :phone, limit: 20
      t.string :address, limit: 255
      t.date :dob
      t.integer :create_user_id # null: false
      t.integer :updated_user_id # null: false
      t.integer :deleted_user_id
      t.datetime :deleted_at
      # t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
