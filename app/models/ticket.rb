class Ticket < ActiveRecord::Base
    has_many :user_tickets, dependent: :destroy 
    belongs_to :owner, polymorphic: true
    belongs_to :mcategory
end
