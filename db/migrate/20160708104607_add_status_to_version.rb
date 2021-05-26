class AddStatusToVersion < ActiveRecord::Migration[4.2]
  def change
    add_column :versions, :status, :string
    add_column :versions, :whodunnit_email, :string
    add_column :versions, :ip, :string
    add_column :versions, :user_agent, :string
  end
end
