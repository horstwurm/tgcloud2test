class Planning < ApplicationRecord
    belongs_to :user
    belongs_to :mobject
    
    after_validation :update_jahrmonat
    
    def update_jahrmonat
      if self.monat.length == 1
        self.monat = "0"+self.monat
      end
      self.jahrmonat = self.jahr+"-"+self.monat

    end

end
