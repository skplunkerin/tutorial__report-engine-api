class CreatePropertiesUsers < ActiveRecord::Migration
  def change
    create_table :properties_users do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :property, index: true, foreign_key: true
    end
  end
end
