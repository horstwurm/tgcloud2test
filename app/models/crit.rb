class Crit < ApplicationRecord
    belongs_to :mobject
    has_many :idea_ratings
end
