class CreateGroupsTransactions < ActiveRecord::Migration
  def change
    create_join_table :groups, :transactions do |t|
      t.index :group_id
      t.index :transaction_id
    end
  end
end
