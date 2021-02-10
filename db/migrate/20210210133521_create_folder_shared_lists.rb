class CreateFolderSharedLists < ActiveRecord::Migration[6.0]
  def change
    create_table :folder_shared_lists do |t|
      t.references :shared_list, null: false, foreign_key: true
      t.references :folder, null: false, foreign_key: true

      t.timestamps
    end
  end
end
