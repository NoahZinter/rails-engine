class Api::V1::RevenueController < ApplicationController
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
end