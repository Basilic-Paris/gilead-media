class AddAasmStateToDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :documents, :aasm_state, :string
  end
end
