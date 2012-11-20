class CreateTicketCategories < ActiveRecord::Migration
  def change
    create_table :ticket_categories do |t|
      t.string :name
      t.text :hint_text
      t.timestamps
    end
    
    ActiveRecord::Base.connection.execute("insert into ticket_categories(name, hint_text, created_at, updated_at) values('Delivery', 'Please inlcude your order number', '#{Time.now}', '#{Time.now}')");
    ActiveRecord::Base.connection.execute("insert into ticket_categories(name, hint_text, created_at, updated_at) values('Return', 'Please inlcude your order number', '#{Time.now}', '#{Time.now}')");
    
  end
end
