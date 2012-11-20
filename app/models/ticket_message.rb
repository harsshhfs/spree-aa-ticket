
  class TicketMessage < ActiveRecord::Base
    belongs_to :ticket, :class_name => "Ticket", :foreign_key => "ticket_id"
    belongs_to :user, :class_name => "Spree::User"
    belongs_to :transfered_to_user, :class_name => "Spree::User", :foreign_key => "transfered_to_user_id"
    belongs_to :ticket_state, :class_name => "TicketState", :foreign_key => "state_id"
    
    #before_create :set_info
    
    def set_info
    
        self.state_id = self.ticket.state_id if self.state_id.nil?
    
        self.user_id = self.ticket.user.id if self.user_id.nil?
    
        self.is_visible_to_customer = true if self.is_visible_to_customer.nil?
    
        self.is_internal_transfer = false if self.is_internal_transfer.nil?
    
    end
    
    def is_internal_transfer
      if self.state_id == TicketState.state_ticket_transfered.id
        return true
      else
        return false
      end
    end
    
    def is_admin_message?
      return self.user.admin_user?
    end
    
    def admin_signiture
      if is_admin_message?
        return "<br/><br/><i>Kind Regards,<br/>#{user_full_name(self.user)}<br/>Better Be Quick Customer Service</i>".html_safe        
      end
    end
    
    def user_full_name(user)
      if !user.last_name.nil?
        return user.first_name + " " + user.last_name
      else
        return user.first_name
      end
    end
  end

