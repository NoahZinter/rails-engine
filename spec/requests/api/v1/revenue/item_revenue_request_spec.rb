require 'rails_helper'

RSpec.describe 'Item Revenue Requests' do
  describe 'top items' do
    it 'returns top x items by revenue' do
      get '/api/v1/revenue/items?quantity=5'

      expect(response.status).to eq 200

      items = JSON.parse(response.body, symbolize_names: true)
      items = items[:data]

      expect(items.count).to eq 5
      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).is_a? String
        expect(item).to have_key(:type)
        expect(item[:type]).to eq 'item_revenue'
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).is_a? String
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).is_a? String
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).is_a? Float
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).is_a? Integer
        expect(item[:attributes]).to have_key(:revenue)
        expect(item[:attributes][:revenue]).is_a? Float
      end
    end

    it 'defaults to 10 items' do
      get '/api/v1/revenue/items?quantity='

      expect(response.status).to eq 200

      items = JSON.parse(response.body, symbolize_names: true)
      items = items[:data]

      expect(items.count).to eq 10
      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).is_a? String
        expect(item).to have_key(:type)
        expect(item[:type]).to eq 'item_revenue'
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).is_a? String
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).is_a? String
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).is_a? Float
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).is_a? Integer
        expect(item[:attributes]).to have_key(:revenue)
        expect(item[:attributes][:revenue]).is_a? Float
      end
    end

    it 'returns error for negative quantity' do
      get '/api/v1/revenue/items?quantity=-1'

      expect(response.status).to eq 400

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error[:errors].first[:id]).to eq nil
      expect(error[:errors].first[:message]).to eq 'invalid quantity'
    end
  end
end