require 'sinatra'
require 'stripe'
require 'dotenv'
require 'json'

Dotenv.load

Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']

get '/' do
  status 200
  return "Great, your backend is set up. Now you can configure the Stripe example iOS apps to point here."
end

post '/charge' do

# Get the credit card details submitted by the form
token = params[:stripeToken]
email = params[:email]
plan = params[:plan]

# Create a Customer
customer = Stripe::Customer.create(
  :source => token,
  :plan => plan,
  :receipt_email => email,
  :description => "Signed Me Up"
)
  rescue Stripe::StripeError => e
    status 402
    return "Error creating charge: #{e.message}"
  end

  status 200
  return "Charge successfully created"

end


end
