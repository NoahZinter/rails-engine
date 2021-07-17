class Api::V1::ItemMerchantController < ApplicationController
  def show
    render json: Merchant.find(params[:id])
  end
end