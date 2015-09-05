class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :limit => 100, :null => false
      t.string :password_digest
      t.string :fullname, :limit => 130, :null => false
      t.string :facebook, :limit => 200
      t.string :email_token, :limit => 200
      t.boolean :is_an_administrator, :default => false
      t.boolean :activated, :default => true

      t.timestamps null: false

      t.index :email, :unique => true
      t.index :activated, :order => :desc
    end
  end
end
