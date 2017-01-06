class UserTicket < ActiveRecord::Base
    belongs_to :user
    belongs_to :ticket
    
    has_attached_file :avatar, default_url: "/images/:style/missing.png", :styles => {:medium => "250x250#", :small => "50x50#" }
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

    def buildQRCode(content)
      qr = RQRCode::QRCode.new(content, size: 12, :level => :h)
      qr_img = qr.to_img
      qr_img.resize(200, 200).save("ticketqrcode.png")
      img = File.open("ticketqrcode.png")
    end
end
