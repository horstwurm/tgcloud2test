json.extract! question, :id, :mobject_id, :name, :description, :sequence, :mcategory_id, :created_at, :updated_at
json.url question_url(question, format: :json)