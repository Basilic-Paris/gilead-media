class AddUserValidityDownloadCodeToSharedFolders < ActiveRecord::Migration[6.0]
  def change
    add_reference :shared_folders, :user, null: false, foreign_key: true
    add_column :shared_folders, :validity, :date
    add_column :shared_folders, :download, :boolean
    add_column :shared_folders, :code, :string
  end
end
