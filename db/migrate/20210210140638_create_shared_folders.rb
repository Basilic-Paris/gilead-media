class CreateSharedFolders < ActiveRecord::Migration[6.0]
  def change
    create_table :shared_folders do |t|
      t.references :folder, null: false, foreign_key: true
      t.references :shared_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
