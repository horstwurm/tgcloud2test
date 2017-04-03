class Question < ApplicationRecord
    belongs_to :mobject
    belongs_to :mcategory
    
    has_many :answers, dependent: :destroy 
    
end
