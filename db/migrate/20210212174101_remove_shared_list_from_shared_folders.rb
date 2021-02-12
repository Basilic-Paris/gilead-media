class RemoveSharedListFromSharedFolders < ActiveRecord::Migration[6.0]
  def change
    remove_reference :shared_folders, :shared_list, null: false, foreign_key: true
  end
end
