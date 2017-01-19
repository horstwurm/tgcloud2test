class Appparam < ActiveRecord::Base
    has_many :credentials, dependent: :destroy 
end
