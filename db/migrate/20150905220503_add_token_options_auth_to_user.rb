class AddTokenOptionsAuthToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_token_created_at, :datetime, default: Time.now, null: false
    add_column :users, :email_token_valid, :boolean, default: false, null: false

    add_index :users, :email_token_created_at, :order => :desc
    add_index :users, :email_token_valid, :order => :desc
  end
end
