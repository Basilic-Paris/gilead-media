class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.string :title
      t.string :language
      t.text :usage
      t.datetime :validation_at, precision: 6
      t.string :format

      t.timestamps
    end
  end
end
