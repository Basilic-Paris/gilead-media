class CreateDocumentFolders < ActiveRecord::Migration[6.0]
  def change
    create_table :document_folders do |t|
      t.references :document, null: false, foreign_key: true
      t.references :folder, null: false, foreign_key: true

      t.timestamps
    end
  end
end
