# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

Rails.configuration.stripe = {
  :publishable_key => 'pk_test_OTSDzUcrUDcCngntSiklicLM',
  :secret_key      => 'sk_test_7T6oDKnp0hvwcBj5Qhihzctg'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]