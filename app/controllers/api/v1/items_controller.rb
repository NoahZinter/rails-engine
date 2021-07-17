class Api::V1::ItemsController < ApplicationController
  def index
    items_per_page = params.fetch(:per_page, 20).to_i
    page = params.fetch(:page, 0).to_i
    render json: Item.offset(page * items_per_page).limit(items_per_page)
  end

  def show
    render json: Item.find(params[:id])
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: item
    else
      render json: {
        error: "Missing or incorrect item params",
        status: 400
      }, status: 400
    end
  end

  def update
    render json: Item.update(params[:id], item_params)
  end

  def destroy
    render json: Item.destroy(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end