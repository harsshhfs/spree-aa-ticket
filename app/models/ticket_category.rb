
  class TicketCategory < ActiveRecord::Base

    has_many :ticket_faqs, :class_name => "TicketFaq", :foreign_key => "category_id"
    has_many :tickets, :class_name => "Ticket", :foreign_key => "category_id"
    
  end

