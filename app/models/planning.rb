class Planning < ApplicationRecord
    belongs_to :user
    belongs_to :mobject
    
    after_validation :update_jahrmonat
    
    def update_jahrmonat
      if self.month.length == 1
        self.month = "0"+self.month
      end
      self.jahrmonat = self.year+"-"+self.month

    end

end
