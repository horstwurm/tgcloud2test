class IdeaRating < ApplicationRecord
    belongs_to :user
    belongs_to :idea
    belongs_to :crit
end
