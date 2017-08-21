class Dataloader < ApplicationRecord
    belongs_to :mcategory
    
    has_attached_file :document
    #validates_attachment :document, :content_type => { :content_type => %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)}

    validates_attachment :document, :content_type => { :content_type => ["application/vnd.ms-excel","application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"]}, message: ' Only EXCEL files are allowed.'
end
