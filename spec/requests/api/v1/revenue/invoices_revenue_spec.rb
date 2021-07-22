require 'rails_helper'

RSpec.describe 'Invoice Revenue Requests' do
  describe 'unshipped' do
    it 'returns potential revenue of unshipped invoices' do
      get '/api/v1/revenue/unshipped?quantity=2'

      expect(response.status).to eq 200

      invoices = JSON.parse(response.body, symbolize_names: true)
      invoices = invoices[:data]

      expect(invoices.length).to eq 2
      invoices.each do |invoice|
        expect(invoice).to have_key(:id)
        expect(invoice[:id]).is_a? String
        expect(invoice).to have_key(:type)
        expect(invoice[:type]).is_a? String
        expect(invoice).to have_key(:attributes)
        expect(invoice[:attributes]).is_a? Hash
        expect(invoice[:attributes][:potential_revenue]).is_a? Float
      end
    end

    it 'returns 10 by default' do
      get '/api/v1/revenue/unshipped?quantity='

      expect(response.status).to eq 200

      invoices = JSON.parse(response.body, symbolize_names: true)
      invoices = invoices[:data]

      expect(invoices.length).to be <= 10
      invoices.each do |invoice|
        expect(invoice).to have_key(:id)
        expect(invoice[:id]).is_a? String
        expect(invoice).to have_key(:type)
        expect(invoice[:type]).is_a? String
        expect(invoice).to have_key(:attributes)
        expect(invoice[:attributes]).is_a? Hash
        expect(invoice[:attributes][:potential_revenue]).is_a? Float
      end
    end

    it 'returns error for negative quantity' do
      get '/api/v1/revenue/unshipped?quantity=-1'

      expect(response.status).to eq 400

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error[:errors].first[:id]).to eq nil
      expect(error[:errors].first[:message]).to eq 'invalid quantity'
    end
  end
end
