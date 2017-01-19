class Credential < ApplicationRecord
    belongs_to :user
    belongs_to :appparam
end
