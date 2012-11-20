class CreateTicketAssignees < ActiveRecord::Migration
  def change
    create_table :ticket_assignees do |t|
      t.integer :ticket_id
      t.integer :user_id
      t.boolean :active
      t.timestamps
    end
    
    add_index :ticket_assignees, [:ticket_id]
  end
end
