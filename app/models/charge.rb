class Charge < ApplicationRecord
    belongs_to :owner, polymorphic: true
end
