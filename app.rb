require 'sinatra'
require 'stripe'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

get '/' do
  erb :index
end

post '/charge' do
  @amount = 1321600

  customer = Stripe::Customer.create(
    :email => params[:email],
    :card  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Le Wagon Mexico',
    :currency    => 'brl',
    :customer    => customer
  )

  erb :charge

end

error Stripe::CardError do
  env['sinatra.error'].message
end

__END__

@@ layout
  <!DOCTYPE html>
  <html>
  <head></head>
  <body>
  <a href="http://www.lewagon.com/mexico"><img src="https://le-wagon-mexico-pagos.herokuapp.com/images/logo_circle.png" style="width: 160px; display: block; margin: 0 auto; left: 0; right: 0;"></a>
    <%= yield %>
  </body>
  </html>

@@index
<div style="text-align: center; padding-top: 50px;">
  <h1 style="font-family: helvetica; color: #D23333;">LE WAGON <strong>MEXICO</strong><br>Bootcamp February 2019</h1>
  <form action="/charge" method="post">


    <script
      src="https://checkout.stripe.com/v3/checkout.js"
      class="stripe-button"
      data-key="<%= settings.publishable_key %>"
      data-name="Fast Foo Treinamentos"
      data-image="https://le-wagon-mexico-pagos.herokuapp.com/images/logo_circle.png"
      data-amount="1321600"
      data-currency="brl"
      data-description="Le Wagon Bootcamp"
      data-zip-code="true"
      data-billing-address="true"
      data-locale="auto">
    </script>
  </form>

</div>

@@charge
<div style="text-align: center; padding-top: 200px;">
  <h2 style="font-family: helvetica;">Thank you very much for the payment of 68,134 MXN and .. Welcome on board!</h2>
</div>
