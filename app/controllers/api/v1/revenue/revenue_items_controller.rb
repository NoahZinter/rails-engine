class Api::V1::Revenue::RevenueItemsController < ApplicationController 
  def top_items
    if params[:quantity].to_i < 0
      data = { errors: [] }
      data[:errors] << {id: nil, message: 'invalid quantity'}
      render json: data, status: 400
    elsif params[:quantity] && (params[:quantity] != '')
      items = Item.top_by_revenue(params[:quantity])
      render json: ItemRevenueSerializer.new(items).serializable_hash.to_json
    else
      items = Item.top_by_revenue(10)
      render json: ItemRevenueSerializer.new(items).serializable_hash.to_json
    end
  end
end