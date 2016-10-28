class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :engine_id
      t.string :name
      t.string :email
      t.string :status
      t.text :notes
      t.string :password_hash
      t.string :password_salt
      t.string :apikey
      t.datetime :deleted_date

      t.timestamps null: false
    end
  end
end
