class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :number
      t.text :subject
      t.integer :user_id
      t.timestamp :closed_at
      t.integer :closed_by
      t.integer :state_id
      t.integer :category_id
      t.integer :admin_user_id
      t.timestamps
    end
    
    add_index :tickets, [:number]
    add_index :tickets, [:user_id, :state_id, :updated_at]
    add_index :tickets, [:admin_user_id, :state_id, :updated_at]
    add_index :tickets, [:updated_at]
    
  end
end
