class Api::V1::Revenue::RevenueMerchantsController < ApplicationController
  def top_merchants
    if params[:quantity] && (params[:quantity] != '')
      merchants = Merchant.top_merchants_by_revenue(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(merchants).serializable_hash.to_json
    else
      data = { errors: [] }
      data[:errors] << {id: nil, message: 'invalid quantity'}
      render json: data, status: 400
    end
  end

  def revenue_show
    merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(merchant).serializable_hash.to_json
  end
end
