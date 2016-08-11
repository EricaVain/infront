require 'sinatra'
require 'stripe'
require 'dotenv'
require 'json'

Dotenv.load


# Set your secret key: remember to change this to your live secret key in production
# See your keys here https://dashboard.stripe.com/account/apikeys
Stripe.api_key = "sk_test_eaeGvpJQ51LC1omnd4AISycn"

get '/' do
  status 200
  return "Great, your backend is set up. Now you can configure the Stripe example iOS apps to point here."
end




# Get the credit card details submitted by the form
token = params[:stripeToken]

# Create a Customer
customer = Stripe::Customer.create(
  :source => token,
  :description => "Example customer",
  :email => "no@vainllc.com",
  :plan => "1001"
)

# Charge the Customer instead of the card
Stripe::Charge.create(
    :amount => 1000, # in cents
    :currency => "usd",
    :customer => customer.id
)

# YOUR CODE: Save the customer ID and other info in a database for later!

# YOUR CODE: When it's time to charge the customer again, retrieve the customer ID!

Stripe::Charge.create(
  :amount   => 1500, # $15.00 this time
  :currency => "usd",
  :customer => customer_id # Previously stored, then retrieved
)

begin
  # Use Stripe's library to make requests...
rescue Stripe::CardError => e
  # Since it's a decline, Stripe::CardError will be caught
  body = e.json_body
  err  = body[:error]

  puts "Status is: #{e.http_status}"
  puts "Type is: #{err[:type]}"
  puts "Code is: #{err[:code]}"
  # param is '' in this case
  puts "Param is: #{err[:param]}"
  puts "Message is: #{err[:message]}"
rescue Stripe::RateLimitError => e
  # Too many requests made to the API too quickly
rescue Stripe::InvalidRequestError => e
  # Invalid parameters were supplied to Stripe's API
rescue Stripe::AuthenticationError => e
  # Authentication with Stripe's API failed
  # (maybe you changed API keys recently)
rescue Stripe::APIConnectionError => e
  # Network communication with Stripe failed
rescue Stripe::StripeError => e
  # Display a very generic error to the user, and maybe send
  # yourself an email
rescue => e
  # Something else happened, completely unrelated to Stripe
end