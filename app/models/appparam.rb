class Appparam < ActiveRecord::Base
    has_many :credentials, dependent: :destroy 
    has_many :charges, dependent: :destroy 
end
