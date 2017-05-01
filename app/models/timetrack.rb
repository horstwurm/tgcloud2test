class Timetrack < ApplicationRecord
    belongs_to :mobject
    belongs_to :user

    validates :datum, presence: true
    after_validation :update_jahrmonat
    
    def update_jahrmonat
      self.jahrmonat = self.datum.strftime('%Y')+"-"+self.datum.strftime('%m') 
    end

end
