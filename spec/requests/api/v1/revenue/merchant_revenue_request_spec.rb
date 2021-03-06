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

  describe 'merchant_revenue' do
    it 'returns total revenue of a merchant' do
      id = Merchant.find(10).id
      get "/api/v1/revenue/merchants/#{id}"

      expect(response.status).to eq 200

      revenue = JSON.parse(response.body, symbolize_names: true)
      data = revenue[:data]
      attributes = revenue[:data][:attributes]
  
      expect(data).to have_key(:id)
      expect(data[:id]).to eq id.to_s
      expect(data).to have_key(:type)
      expect(data[:type]).to eq 'merchant_revenue'
      expect(attributes).to have_key(:revenue)
      expect(attributes[:revenue]).is_a? Float
    end
  end
end