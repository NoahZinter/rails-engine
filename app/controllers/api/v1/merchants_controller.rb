class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.offset(page * per_page).limit(per_page)
  end

  def show
    render json: Merchant.find(params[:id])
  end

end