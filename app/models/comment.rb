class Comment < ApplicationRecord
    belongs_to :mobject
    belongs_to :user
end
