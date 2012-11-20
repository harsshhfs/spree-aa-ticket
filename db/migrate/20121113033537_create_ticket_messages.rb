class CreateTicketMessages < ActiveRecord::Migration
  def change
    create_table :ticket_messages do |t|
      t.integer :ticket_id
      t.text :message_text
      t.integer :user_id
      t.integer :transfered_to_user_id
      t.integer :state_id
      t.boolean :is_visible_to_customer, :default => false
      t.timestamps
    end
    
    add_index :ticket_messages, [:ticket_id]
    add_index :ticket_messages, [:updated_at]
    
  end
end
