json.extract! charge, :id, :owner_id, :owner_type, :stripe_id, :amount, :plan, :created_at, :updated_at
json.url charge_url(charge, format: :json)