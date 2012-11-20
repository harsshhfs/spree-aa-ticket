class CreateAaTicketStates < ActiveRecord::Migration
  def change
    create_table :ticket_states do |t|
      t.string :name
      t.string :display_name
      t.timestamps
    end
    ActiveRecord::Base.connection.execute("insert into ticket_states(name, display_name, created_at, updated_at) values('Closed', 'Closed', '#{Time.now}', '#{Time.now}')");
    ActiveRecord::Base.connection.execute("insert into ticket_states(name, display_name, created_at, updated_at) values('New', 'Open', '#{Time.now}', '#{Time.now}')");
    ActiveRecord::Base.connection.execute("insert into ticket_states(name, display_name, created_at, updated_at) values('Require Customer Response', 'Open', '#{Time.now}', '#{Time.now}')");
    ActiveRecord::Base.connection.execute("insert into ticket_states(name, display_name, created_at, updated_at) values('Customer Responded', 'Open', '#{Time.now}', '#{Time.now}')");
    ActiveRecord::Base.connection.execute("insert into ticket_states(name, display_name, created_at, updated_at) values('Ticket Transfered', 'Open', '#{Time.now}', '#{Time.now}')");
    ActiveRecord::Base.connection.execute("insert into ticket_states(name, display_name, created_at, updated_at) values('Resolved', 'Open', '#{Time.now}', '#{Time.now}')");

  end
end
