
  class TicketFaq < ActiveRecord::Base
    belongs_to :ticket_category, :class_name => "TicketCategory", :foreign_key => "category_id"
  end

