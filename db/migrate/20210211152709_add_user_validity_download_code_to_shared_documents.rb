class AddUserValidityDownloadCodeToSharedDocuments < ActiveRecord::Migration[6.0]
  def change
    add_reference :shared_documents, :user, null: false, foreign_key: true
    add_column :shared_documents, :validity, :date
    add_column :shared_documents, :download, :boolean
    add_column :shared_documents, :code, :string
  end
end
