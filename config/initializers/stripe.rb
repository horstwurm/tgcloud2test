# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

Rails.configuration.stripe = {
  :publishable_key => ENV['stripe_publishable_key'],
  :secret_key => ENV['stripe_secret_key']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]