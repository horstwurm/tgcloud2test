json.extract! timetrack, :id, :user_id, :mobject_id, :activity, :amount, :datum, :created_at, :updated_at
json.url timetrack_url(timetrack, format: :json)