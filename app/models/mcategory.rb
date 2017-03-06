class Mcategory < ActiveRecord::Base
    has_many :mobjects
    has_many :companies
    has_many :articles
end
