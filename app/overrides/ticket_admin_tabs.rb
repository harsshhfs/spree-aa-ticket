Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "ticket_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%= tab(:tickets, :url => myopen_admin_tickets_path) %>",
                     :disabled => false)