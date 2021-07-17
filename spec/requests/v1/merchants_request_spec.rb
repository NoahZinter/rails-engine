require 'rails_helper'

describe 'Merchants Requests' do
  describe '#index' do
    it 'returns list of merchants' do
      create_list(:merchant, 50)

      get '/api/v1/merchants'

      expect(response.status).to eq 200

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.count).to eq 50
    end
  end



end