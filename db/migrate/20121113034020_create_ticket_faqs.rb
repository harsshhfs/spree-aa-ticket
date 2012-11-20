class CreateTicketFaqs < ActiveRecord::Migration
  def change
    create_table :ticket_faqs do |t|
      t.integer :category_id
      t.text :question
      t.text :answer
      t.timestamps
    end
    add_index :ticket_faqs, [:category_id]
  end
end
