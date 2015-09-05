class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, :limit => 100
      t.boolean :activated, :default => true

      t.timestamps null: false

      t.index :name, :unique => true
      t.index :activated, :order => :desc
    end
  end
end
