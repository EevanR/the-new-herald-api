class Api::V1::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  rescue_from Stripe::InvalidRequestError, with: :invalid_token_id

  def create

    if params[:stripeToken]
      customer = Stripe::Customer.create(
        email: current_user.email,
        source: params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        customer: customer.id,
        currency: 'sek',
        amount: 999,
        description: I18n.t('stripe.description')
      )
      
      if (charge.paid)
        current_user.role = 'subscriber'
        current_user.save
        render json: { message: I18n.t('stripe.pay_success')}
      end
    else
      render json: { message: I18n.t('stripe.missing_token')}
    end
  end
  
  private

  def invalid_token_id
    render json: { message: I18n.t('stripe.pay_failure')}
  end 

end