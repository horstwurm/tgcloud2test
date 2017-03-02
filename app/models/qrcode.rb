class Qrcode < ApplicationRecord
    has_attached_file :avatar, default_url: "/images/:style/missing.png", :styles => {:medium => "250x250#", :small => "150x150#" }
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
