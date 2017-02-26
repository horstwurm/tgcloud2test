class Signage < ApplicationRecord
    belongs_to :signage_camp
    
    has_attached_file :avatar, default_url: "/images/:style/missing.png", :styles => {:native => "1200x1000", :big => "1200x1000#", :medium => "250x250#"}
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

end
