json.extract! user_answer, :id, :answer_id, :user_id, :num, :description, :status, :created_at, :updated_at
json.url user_answer_url(user_answer, format: :json)