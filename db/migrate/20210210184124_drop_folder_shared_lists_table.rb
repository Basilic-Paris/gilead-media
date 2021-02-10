class DropFolderSharedListsTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :folder_shared_lists
  end
end
