class Deputy < ApplicationRecord
    belongs_to :owner, polymorphic: true
end
