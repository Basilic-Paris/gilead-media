class AddAasmStateToSharedLists < ActiveRecord::Migration[6.0]
  def change
    add_column :shared_lists, :aasm_state, :string
  end
end
