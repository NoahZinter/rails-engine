class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.limit(per_page).offset(page * per_page)
    render json: ItemSerializer.new(items).serializable_hash.to_json
  end

  def search
    if params[:name] && params[:name] != ''
      item = Item.find_all_by_name(params[:name])
      render json: ItemSerializer.new(item).serializable_hash.to_json
    else
      render json: {
        error: "Must enter valid name query",
        status: 400
      }, status: 400
    end
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item).serializable_hash.to_json
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item).serializable_hash.to_json, status: 201
    else
      render json: {
        error: "Missing or incorrect item params",
        status: 400
      }, status: 400
    end
  end

  def update
    updated = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(updated).serializable_hash.to_json
  end

  def destroy
    Item.destroy(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end