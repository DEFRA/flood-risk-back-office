class AddUniqueSessionIdToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :unique_session_id, :string, limit: 20
  end
end
