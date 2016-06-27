class RenameUserVersionsTable < ActiveRecord::Migration
  def change
    rename_table :user_versions, :versions
  end
end
