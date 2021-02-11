class AddAasmStateToSharedDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :shared_documents, :aasm_state, :string
  end
end
