require 'rails_helper'

RSpec.describe 'Items Merchant Request' do
  describe '#show' do
    it 'shows merchant data for given item' do
      merch_id = create(:merchant).id
      item_id = create(:item, merchant_id: merch_id).id
      get "/api/v1/items/#{item_id}/merchant"
      merchant = JSON.parse(response.body, symbolize_names: true)
      merchant = merchant[:data]

      expect(response.status).to eq 200
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).is_a? String
      expect(merchant[:id]).to eq merch_id.to_s
    end
  end
  # Test 404 message for incorrect merchant
end