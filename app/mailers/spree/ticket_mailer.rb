module Spree
  class TicketMailer < ActionMailer::Base
     helper 'spree/base'
     
     def new_ticket_mail(user, ticket)     
       @user = user
       @ticket = ticket
       @ticket_url = "http://" + Spree::Config[:site_url] + support_ticket_path(ticket.number)
       mail(:to => user.email,
           :subject => Spree::Config[:site_name] + " Ticket ##{ticket.number} has been opened" )
     end

     def updated_ticket_mail(user, ticket, message)     
       @user = user
       @ticket = ticket
       @message = message
       @ticket_url = "http://" + Spree::Config[:site_url] + support_ticket_path(ticket.number)
       mail(:to => user.email,
           :subject => Spree::Config[:site_name] + " Ticket ##{ticket.number} has been updated" )
     end
  
  end
end
