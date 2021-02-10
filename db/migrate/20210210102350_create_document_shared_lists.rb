class CreateDocumentSharedLists < ActiveRecord::Migration[6.0]
  def change
    create_table :document_shared_lists do |t|
      t.bigint "shared_list_id", null: false
      t.bigint "document_id", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["document_id"], name: "index_document_shared_lists_on_document_id"
      t.index ["shared_list_id"], name: "index_document_shared_lists_on_shared_list_id"
    end
  end
end
