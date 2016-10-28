class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :property_id
      t.string :name
      t.text :summary
      t.string :status
      t.datetime :publish_date
      t.string :version
      t.text :notes
      t.datetime :initial_view_date
      t.integer :view_count
      t.string :apikey
      t.datetime :deleted_date

      t.timestamps null: false
    end
  end
end
