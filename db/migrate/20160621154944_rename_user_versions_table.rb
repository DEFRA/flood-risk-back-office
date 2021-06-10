class RenameUserVersionsTable < ActiveRecord::Migration[4.2]
  def change
    rename_table :user_versions, :versions
  end
end
