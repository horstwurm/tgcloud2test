class SignageLoc < ApplicationRecord
    belongs_to :owner, polymorphic: true
    has_many :signage_cals, dependent: :destroy 

    has_attached_file :avatar, default_url: "/images/:style/missing.png", :styles => {:big => "800x600#", :medium => "250x250#", :small => "50x50#"}
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

    def update_geo_address
      self.geo_address = self.address1 + " " + address2 + " " + address3
    end
    before_validation :update_geo_address
    geocoded_by :geo_address
    after_validation :geocode
    
end
