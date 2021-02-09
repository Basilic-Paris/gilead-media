class AddValidityDownloadCodeToSharedLists < ActiveRecord::Migration[6.0]
  def change
    add_column :shared_lists, :validity, :date
    add_column :shared_lists, :download, :boolean
    add_column :shared_lists, :code, :string
  end
end
