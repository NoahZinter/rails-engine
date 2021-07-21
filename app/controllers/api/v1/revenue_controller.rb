class Api::V1::RevenueController < ApplicationController
  def top_merchants
    if params[:quantity]
      merchants = Merchant.top_merchants_by_revenue(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(merchants).serializable_hash.to_json
    else
      render json: {
        error: "Must enter quantity",
        status: 400
        }, status: 400
    end
  end
end