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

      expect(items.count).to eq 20
      items.each do |item|
        expect(item).to have_key(:name)
        expect(item[:name]).is_a? String
        expect(item).to have_key(:description)
        expect(item[:description]).is_a? String
        expect(item).to have_key(:unit_price)
        expect(item[:unit_price]).is_a? Float
        expect(item).to have_key(:merchant_id)
        expect(item[:merchant_id]).to eq merch_id
      end
    end
  end
end