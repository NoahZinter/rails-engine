require 'rails_helper'

describe 'Merchants Requests' do
  describe '#index' do
    it 'returns list of merchants' do
      create_list(:merchant, 50)

      get '/api/v1/merchants'

      expect(response.status).to eq 200

      merchants = JSON.parse(response.body, symbolize_names: true)
# Should only return 20. Return to pagination.
      expect(merchants.count).to eq 50

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).is_a? Integer
        expect(merchant).to have_key(:name)
        expect(merchant[:name]).is_a? String
      end
    end
  end

  describe '#show' do
    it 'returns a given merchant' do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      expect(response.status).to eq 200

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).is_a? Integer
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).is_a? String
    end
  end
end