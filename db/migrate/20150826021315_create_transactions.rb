class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :name, :limit => 100
      t.boolean :can_read, :default => true
      t.boolean :can_edit, :default => true
      t.boolean :can_create, :default => true
      t.boolean :can_delete, :default => true
      t.boolean :activated, :default => true

      t.timestamps null: false

      t.index :name, :unique => true
      t.index :activated, :order => :desc
    end
  end
end
