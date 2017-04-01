json.extract! answer, :id, :question_id, :description, :name, :num, :created_at, :updated_at
json.url answer_url(answer, format: :json)