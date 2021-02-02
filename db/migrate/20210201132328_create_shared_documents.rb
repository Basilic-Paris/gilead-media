class CreateSharedDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :shared_documents do |t|
      t.references :shared_list, null: false, foreign_key: true
      t.references :document, null: false, foreign_key: true

      t.timestamps
    end
  end
end
