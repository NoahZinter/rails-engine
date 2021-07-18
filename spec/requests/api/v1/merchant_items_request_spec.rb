require 'rails_helper'
# Add testing for empty item lists

RSpec.describe 'Merchant Items' do
  describe '#index' do
    it 'lists all items for a merchant' do
      merch_id = create(:merchant).id
      create_list(:item, 20, merchant_id: merch_id)

      get "/api/v1/merchants/#{merch_id}/items"

      expect(response.status).to eq 200

      items = JSON.parse(response.body, symbolize_names: true)
      items = items[:data]

      expect(items.count).to eq 20
      items.each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).is_a? String
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).is_a? String
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).is_a? Float
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).is_a? Integer
      end
    end
  end
end