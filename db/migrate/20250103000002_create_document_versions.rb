class CreateDocumentVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :document_versions do |t|
      t.references :document, null: false, foreign_key: true, index: false
      t.integer :version_number, null: false
      t.string :title, null: false
      t.text :content
      t.timestamps
    end

    add_index :document_versions, [:document_id, :version_number], unique: true
  end
end

