class CreateIssues < ActiveRecord::Migration[8.1]
  def change
    create_table :issues do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false
      t.integer :priority, null: false
      t.text :title, null: false
      t.timestamps
    end

    add_check_constraint :issues, "status IN ('open', 'closed')", name: "check_status"
    add_check_constraint :issues, "priority BETWEEN 1 AND 5", name: "check_priority"
    add_index :issues, :status
    add_index :issues, :user_id
  end
end
