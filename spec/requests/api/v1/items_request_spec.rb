require 'rails_helper'

RSpec.describe 'Items Requests' do
  describe '#index' do
    it 'lists all items, 20 per page' do
      merch_id = create(:merchant).id
      merch_id_2 = create(:merchant).id
      create_list(:item, 20, merchant_id: merch_id)
      create_list(:item, 30, merchant_id: merch_id_2)

      get '/api/v1/items'

      expect(response.status).to eq 200

      items = JSON.parse(response.body, symbolize_names: true)
# Should be 20. Pagination.
      expect(items.count).to eq 50

      items.each do |item|
        expect(item).to have_key(:name)
        expect(item[:name]).is_a? String
        expect(item).to have_key(:description)
        expect(item[:description]).is_a? String
        expect(item).to have_key(:unit_price)
        expect(item[:unit_price]).is_a? Float
        expect(item).to have_key(:merchant_id)
        expect(item[:merchant_id]).is_a? Integer
      end
    end
  end
end