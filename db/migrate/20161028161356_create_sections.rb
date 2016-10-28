class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :report_id
      t.integer :order
      t.string :name
      t.string :status
      t.text :content
      t.string :apikey
      t.datetime :deleted_date

      t.timestamps null: false
    end
  end
end
