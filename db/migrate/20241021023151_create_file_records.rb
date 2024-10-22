class CreateFileRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :file_records do |t|
      t.references :user, null: false, foreign_key: true
      t.string :file_path

      t.timestamps
    end
  end
end
