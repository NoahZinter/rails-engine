class Api::V1::MerchantItemsController < ApplicationController
  def index
    merchant_items = Merchant.find(params[:merchant_id]).items
    render json: MerchantItemsSerializer.new(merchant_items).serializable_hash.to_json
  end
end