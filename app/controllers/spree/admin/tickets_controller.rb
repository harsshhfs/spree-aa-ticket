module Spree
  module Admin
    class TicketsController < Spree::Admin::BaseController
      respond_to :html      
      PER_PAGE = 20
      before_filter :load_search_object, :except => [:edit, :new, :update, :create]

      def load_search_object
        params[:search] ||= {}
        params[:search][:meta_sort] ||= 'updated_at.desc'
        @search = Ticket.metasearch(params[:search])        
      end
      
      def index
       if !params[:search][:created_at_greater_than].blank?
          params[:search][:created_at_greater_than] = Time.zone.parse(params[:search][:created_at_greater_than]).beginning_of_day rescue ""
        end

        if !params[:search][:created_at_less_than].blank?
          params[:search][:created_at_less_than] = Time.zone.parse(params[:search][:created_at_less_than]).end_of_day rescue ""
        end


        @collections = Ticket.metasearch(params[:search]).includes([:user, :admin_user, :ticket_state]).page(params[:page]).per(Spree::Admin::TicketsController::PER_PAGE)
        respond_with(@collections)        
      end
      
      def all
        @collections = Ticket.includes(:user, :admin_user, :ticket_state).order("updated_at desc").page(params[:page]).per(Spree::Admin::TicketsController::PER_PAGE);
        render "index"        
      end
      
      def unassigned
        @collections = Ticket.includes(:user, :admin_user, :ticket_state).where("admin_user_id is null").order("updated_at desc").page(params[:page]).per(Spree::Admin::TicketsController::PER_PAGE);
        render "index"
      end
      
      def myopen
        @collections = Ticket.includes(:user, :admin_user, :ticket_state).where("admin_user_id = ? and state_id != ?", current_user.id, TicketState.state_closed.id).order("updated_at desc").page(params[:page]).per(Spree::Admin::TicketsController::PER_PAGE);
        render "index"        
      end
      
      def mynew
        @collections = Ticket.includes(:user, :admin_user, :ticket_state).where("admin_user_id = ? and state_id != ? and state_id != ? and state_id != ?", current_user.id, TicketState.state_closed.id, TicketState.state_require_customer_response.id, TicketState.state_resolved.id).order("updated_at desc").page(params[:page]).per(Spree::Admin::TicketsController::PER_PAGE);
        render "index"        
      end
      

      def myclose
        @collections = Ticket.includes(:user, :admin_user, :ticket_state).where("admin_user_id = ? and state_id = ?", current_user.id, TicketState.state_closed.id).order("updated_at desc").page(params[:page]).per(Spree::Admin::TicketsController::PER_PAGE);
        render "index"        
      end

      def myall
        @collections = Ticket.includes(:user, :admin_user, :ticket_state).where("admin_user_id = ?", current_user.id).order("updated_at desc").page(params[:page]).per(Spree::Admin::TicketsController::PER_PAGE);
        render "index"        
      end
      
      def edit
        @ticket = Ticket.find_by_number!(params[:id])
        @backend = true
        @message = TicketMessage.new
        admin_role = Spree::Role.find_by_name 'admin'
        @admin_users = admin_role.users
        customer = Spree::User.new
        customer.id = -1
        customer.email = "Cutomer"
        @admin_users.unshift customer                
      end
      
      def update
        @ticket = Ticket.find(params[:id])
        admin_user_id = params[:ticket][:admin_user_id].to_i
        @ticket.state_id = params[:ticket][:state_id].to_i
        message = TicketMessage.new
        message.user_id = current_user.id
        message.message_text =  params[:ticket][:ticket_message][:message_text]
        @ticket.ticket_messages = Array.new if @ticket.ticket_messages.nil?
        message.state_id = params[:ticket][:state_id]
        
        if admin_user_id > 0
            @ticket.admin_user_id = admin_user_id 
            #message.state_id = @ticket.state_id = TicketState.state_ticket_transfered.id                  
        end
        
        if @ticket.state_id == TicketState.state_closed.id
          @ticket.closed_by = current_user.id
          @ticket.closed_at = Time.now
        end
        
        if !@ticket.save
          flash[:error] = "An error occurred. please contact support"
          respond_with(@ticket, :location => edit_admin_ticket_path(@ticket.number))
          return
        end          
        
                  
        if admin_user_id <= 0
          #transfer to customer
            if message.message_text.blank?
              flash[:error] = "Message can not be left blank if sending to customer"
              respond_with(@ticket, :location => edit_admin_ticket_path(@ticket.number))
              return  
            else
              message.transfered_to_user_id = @ticket.user.id
              message.is_visible_to_customer = true
              message.transfered_to_user_id = nil
              #message.is_internal_transfer = false
            end  
        else
            message.is_visible_to_customer = false            
            message.transfered_to_user_id = admin_user_id
            #message.is_internal_transfer = true

        end
        if !(@ticket.ticket_messages.push message)
              flash[:error] = "An error occurred. please contact support"
              respond_with(@ticket, :location => edit_admin_ticket_path(@ticket.number))
              return
        end
        
        if admin_user_id <= 0 && @ticket.state_id == TicketState.state_require_customer_response.id
#          begin
            Spree::TicketMailer.updated_ticket_mail(@ticket.user, @ticket, message).deliver
          # rescue => ex
          #   Rails.logger.info("Can not send ticket opened email: #{ex}")
          # end
        end
        
        flash.notice = "This Ticket has been updated!"
        respond_with(@ticket, :location => edit_admin_ticket_path(@ticket.number))
          
        
      end
      
      def new
        @object = Ticket.new
        @object.ticket_messages = Array.new.push(TicketMessage.new)
        admin_role = Spree::Role.find_by_name 'admin'
        @admin_users = admin_role.users
      end
  
      def create        
      @object = Ticket.new
      @object.user = current_user
      @object.state_id = TicketState.state_new.id
      
      params[:ticket][:ticket_messages_attributes]["0"][:state_id] = @object.state_id
      params[:ticket][:ticket_messages_attributes]["0"][:user_id] = current_user.id
      params[:ticket][:ticket_messages_attributes]["0"][:transfered_to_user_id] = params[:ticket][:admin_user_id]
       
     if @object.update_attributes(params[:ticket])
        begin
          Spree::TicketMailer.new_ticket_mail(@object.user, @object).deliver
        rescue => ex
          Rails.logger.info("Can not send ticket opened email: #{ex}")
        end
        redirect_to :action => :myopen
      else
        flash[:error] = "An error occurred please contact the support"
        redirect_to :action => :new
      end     
    end

      
      # def update
      #  
      # 
      #  message = TicketMessage.new
      #  message.message_text =  params[:ticket][:ticket_message][:message_text]
      #  @ticket.ticket_messages = Array.new if @ticket.ticket_messages.nil?
      #  @ticket.ticket_messages.is_internal_transfer
      #  @ticket.ticket_messages.push message
      #   
      #   end
      #   if @ticket.save
      #     flash.notice = "Thank you. Your ticket has been updated we will respond shortly." if !params[:ticket].blank? && !params[:ticket][:ticket_message].blank? && !params[:ticket][:ticket_message][:message_text].blank?
      #   end        
      #   respond_with(@ticket, :location => admin_ticket_path(@ticket.number))
      # end      
      
    end
  end
end
