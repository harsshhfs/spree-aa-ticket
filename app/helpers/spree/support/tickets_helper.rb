module Spree
  module Support
    module TicketsHelper
      
      # def support_ticket_path(ticket)
      #   return "/support/tickets/new"
      # end
      def message_color(user, is_internal_transfer)
        if is_internal_transfer
          return "ticket-message-transfer"
        end
        if user.admin_user?
          return "ticket-message-admin-color"
        else
          return "ticket-message-customer-color"
        end
      end
      
      def hind_faq(category, first_id)
        return "" if category.id == first_id
        return "hidden"
      end
              
      def message_title(user)
        if !user.admin_user?
          return "Customer said:"
        else
          return "Better Be Quicker Customer Service said:"
        end        
      end
      
      def avialbe_categories
        return TicketCategory.all
      end
      
      def current_page(link_title)
        #Rails.logger.info("PAGE TITLE=========================#{@current_page}===========#{link_title}")
        if @current_page == link_title
          return "class='active'"          
        end
        return ""
      end
      
      def new_aa_ticket_path
        return "/support/tickets/new"
      end
      
      def tickets_sum(amount, type)
        if amount == 1
          return "You have 1 #{type} ticket"
        else
          return "You have #{amount} #{type} tickets"
        end
      end
      
    end
  end
end
