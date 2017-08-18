class Charge < ApplicationRecord
    belongs_to :owner, polymorphic: true
    belongs_to :appparam
end
