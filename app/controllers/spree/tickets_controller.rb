module Spree
  #module Support
    class TicketsController < Spree::ContentController
      respond_to :html
      before_filter :page_title
      before_filter :check_authorization, :except => [:check_login]

      
      def check_login
      end
      
      
      
      def page_title
        @page_title  = 'Support'
      end
      
      def open
        @current_page = "View Open"
        @tickets = Ticket.open_tickets_by_user(current_user)
        @type = "open"
        render "spree/tickets/index"
      end
      
      def close
        @current_page = "View Closed"
        @tickets = Ticket.closed_tickets_by_user(current_user)
        @type = "closed"        
        render "spree/tickets/index"
      end
      
      def all
        @current_page = "View All"
        @tickets = Ticket.all_tickets_by_user(current_user)
        @type = ""
        render "spree/tickets/index"        
      end
      
      def show
        @ticket = Ticket.find_by_number!(params[:id])
        @backend = false
        @message = TicketMessage.new
      end
      
      def closed
        @ticket = Ticket.find_by_number!(params[:id])
        @ticket.ticket_state = TicketState.state_closed
        @ticket.closed_by = current_user.id
        @ticket.closed_at = Time.now
        if @ticket.save
          redirect_to :action => :open
        else
          flash.error = "Sorry there is a problem. Please contact our support if problem continues."
          respond_with(@ticket, :location => support_ticket_path(@ticket.number))
        end
      end
      
      def new
        @current_page = "New Ticket"
        @object = Ticket.new
        @object.ticket_messages = Array.new.push(TicketMessage.new)        
      end
      
      def update
        @ticket = Ticket.find(params[:id])
        @ticket.ticket_state = TicketState.state_customer_responsed
        if !params[:ticket].blank? && !params[:ticket][:ticket_message].blank? && !params[:ticket][:ticket_message][:message_text].blank?
           message = TicketMessage.new
           message.message_text =  params[:ticket][:ticket_message][:message_text]
           message.state_id = @ticket.state_id
           message.user_id = @ticket.user_id
           @ticket.ticket_messages = Array.new if @ticket.ticket_messages.nil?           
           @ticket.ticket_messages.push message           
        end
        if @ticket.save
          flash.notice = "Thank you. Your ticket has been updated we will respond shortly." if !params[:ticket].blank? && !params[:ticket][:ticket_message].blank? && !params[:ticket][:ticket_message][:message_text].blank?
        end        
        respond_with(@ticket, :location => support_ticket_path(@ticket.number))
      end
      
      def create        
        @object = Ticket.new
        @object.user = current_user
        @object.state_id = TicketState.state_new.id
        
        params[:ticket][:ticket_messages_attributes]["0"][:state_id] = @object.state_id
        params[:ticket][:ticket_messages_attributes]["0"][:user_id] = current_user.id
         
       if @object.update_attributes(params[:ticket])
          begin
            Spree::TicketMailer.new_ticket_mail(@object.user, @object).deliver
          rescue => ex
            Rails.logger.info("Can not send ticket opened email: #{ex}")
          end
          redirect_to :action => :open
        else
          flash[:error] = "An error occurred please contact the support"
          redirect_to :action => :new
        end     
      end
      
      private
        def check_authorization
          return if current_user
          store_location
          redirect_to spree.login_path and return          
        end

    end
  #end
end
