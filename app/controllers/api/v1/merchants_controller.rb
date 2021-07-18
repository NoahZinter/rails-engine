class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.offset(page * per_page).limit(per_page)
    render json: MerchantSerializer.new(merchants).serializable_hash.to_json
  end

  def show
    render json: Merchant.find(params[:id])
  end
end