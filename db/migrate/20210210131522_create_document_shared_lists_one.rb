class CreateDocumentSharedListsOne < ActiveRecord::Migration[6.0]
  def change
    create_table :document_shared_lists do |t|
      t.references :document, null: false, foreign_key: true
      t.references :shared_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
