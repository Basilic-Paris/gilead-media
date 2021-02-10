class CreateDocumentSharedListsOne < ActiveRecord::Migration[6.0]
  def change
    drop_table :document_shared_lists
  end
end
