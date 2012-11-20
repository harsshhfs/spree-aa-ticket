
  class TicketState < ActiveRecord::Base
    has_many :ticket_assignees, :class_name => "TicketAssignee", :foreign_key => "state_id"
    has_many :ticket_messages, :class_name => "TicketMessage", :foreign_key => "state_id"
    has_many :tickets, :class_name => "Ticket", :foreign_key => "state_id"
    
    CLOSED = "Closed"
    NEW = "New"
    REQUIRE_CUSTOMER_RESPONSE = "Require Customer Response"
    CUSTOMER_RESPONDED = "Customer Responded"
    TICKET_TRANSFERED = "Ticket Transfered"
    RESOLVED = "Resolved"

    def self.state_closed
      return TicketState.find_by_name TicketState::CLOSED
    end
    
    def self.state_new
      return TicketState.find_by_name TicketState::NEW
    end

    def self.state_require_customer_response
      return TicketState.find_by_name TicketState::REQUIRE_CUSTOMER_RESPONSE
    end

    def self.state_customer_responsed
      return TicketState.find_by_name TicketState::CUSTOMER_RESPONDED
    end

    def self.state_ticket_transfered
      return TicketState.find_by_name TicketState::TICKET_TRANSFERED
    end

    def self.state_resolved
      return TicketState.find_by_name TicketState::RESOLVED
    end
    
  end

