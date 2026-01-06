class CreateDocumentActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :document_activities do |t|
      t.references :document, null: false, foreign_key: true
      t.string :activity_type, null: false
      t.text :description
      t.integer :performed_by_id
      t.timestamps
    end

    add_index :document_activities, :activity_type
    add_index :document_activities, :performed_by_id
  end
end
