class AddDeletedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      add_column :users, :deleted_at, :datetime
      add_index :users, :deleted_at
    end
  end
end
