class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :engine_id
      t.integer :user_id
      t.string :name
      t.string :status
      t.text :notes
      t.string :apikey
      t.datetime :deleted_date

      t.timestamps null: false
    end
  end
end
