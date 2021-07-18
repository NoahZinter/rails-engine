class Api::V1::ItemMerchantController < ApplicationController
  def show
    merchant = Item.find(params[:item_id]).merchant
    render json: MerchantSerializer.new(merchant).serializable_hash.to_json
  end
end