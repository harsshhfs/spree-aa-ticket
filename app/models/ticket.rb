
  class Ticket < ActiveRecord::Base
    belongs_to :ticket_category, :class_name => "TicketCategory", :foreign_key => "category_id"
    belongs_to :ticket_state, :class_name => "TicketState", :foreign_key => "state_id"
    has_many :ticket_messages, :class_name => "TicketMessage",  :foreign_key => "ticket_id"
    #has_many :ticket_assignees, :class_name => "TicketAssignee", :foreign_key => "ticket_id"
    belongs_to :user, :class_name => "Spree::User", :foreign_key => "user_id"
    belongs_to :closed_by_user, :class_name => "Spree::User", :foreign_key => "closed_by"
    belongs_to :admin_user, :class_name => "Spree::User", :foreign_key => "admin_user_id"

    accepts_nested_attributes_for :ticket_messages
    # validates :subject, :presence => true
    # validates :state_id, :presence => true
    before_create :generate_ticket_number
    
    
    # scope :open, where("state_id != #{TicketState.id_for_closed}").order('updated_at DESC')
    # scope :close, where("state_id = #{TicketState.id_for_closed}").order('updated_at DESC')

    def self.open_tickets_by_user(user)
      return Ticket.where("state_id != ? and user_id = ?", TicketState.state_closed.id, user.id).order('updated_at DESC')      
    end
    
    def self.closed_tickets_by_user(user)
      return Ticket.where("state_id = ? and user_id = ?", TicketState.state_closed.id, user.id).order('updated_at DESC')      
    end
    
    def self.all_tickets_by_user(user)
      return Ticket.where("user_id = ? and state_id is not null", user.id).order('updated_at DESC')      
    end
        
    private
      def generate_ticket_number
        return self.number unless self.number.blank?
        record = true
        while record
          random = "T#{Array.new(9){rand(8)}.join}"
          record = self.class.where(:number => random).first
        end
        self.number = random
      end
        
  end

