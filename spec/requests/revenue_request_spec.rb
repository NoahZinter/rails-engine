require 'rails_helper'

RSpec.describe 'Revenue Requests' do
  describe 'merchants' do
    it 'returns top x merchants by revenue' do
      get '/api/v1/revenue/merchants?quantity=2'

      expect(response.status).to eq 200

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchants = merchants[:data]

      expect(merchants.count).to eq 2
      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).is_a? String
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq 'merchant_name_revenue'
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).is_a? String
        expect(merchant[:attributes]).to have_key(:revenue)
        expect(merchant[:attributes][:revenue]).is_a? Float
      end
    end

    it 'returns an error if no quantity' do
      get '/api/v1/revenue/merchants?quantity='
      expect(response.status).to eq 400

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error[:errors].first[:id]).to eq nil
      expect(error[:errors].first[:message]).to eq 'invalid quantity'
    end
  end

  describe 'items' do
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
  end
end