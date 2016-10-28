class CreateEngines < ActiveRecord::Migration
  def change
    create_table :engines do |t|
      t.string :name
      t.string :status
      t.string :apikey
      t.datetime :deleted_date

      t.timestamps null: false
    end
  end
end
