require 'rails_helper'

RSpec.describe 'Invoice Revenue Requests' do
  describe 'unshipped' do
    it 'returns potential revenue of unshipped invoices' do
      get '/api/v1/revenue/unshipped?quantity=2'

      expect(response.status).to eq 200

      invoices = JSON.parse(response.body, symbolize_names: true)
      invoices = invoices[:data]

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
  end
end
