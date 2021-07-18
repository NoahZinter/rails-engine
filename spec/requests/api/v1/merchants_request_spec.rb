require 'rails_helper'

describe 'Merchants Requests' do
  describe '#index' do
    it 'returns list of merchants, default 20' do
      last_id = create_list(:merchant, 20).last.id
      create_list(:merchant, 60)

      get '/api/v1/merchants'

      expect(response.status).to eq 200

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchants = merchants[:data]

      expect(merchants.count).to eq 20
      expect(merchants.last[:id]).to eq last_id.to_s
      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).is_a? String
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq 'merchant'
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).is_a? String
      end
    end

    it 'returns the same list if page set to 1' do
      last_id = create_list(:merchant, 20).last.id
      create_list(:merchant, 60)

      get '/api/v1/merchants?page=1'

      expect(response.status).to eq 200

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchants = merchants[:data]

      expect(merchants.count).to eq 20
      expect(merchants.last[:id]).to eq last_id.to_s
      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).is_a? String
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq 'merchant'
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).is_a? String
      end
    end

    it 'returns the next 20 merchants' do
      create_list(:merchant, 20)
      first_id = create_list(:merchant, 60).first.id

      get '/api/v1/merchants?page=2'

      expect(response.status).to eq 200

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchants = merchants[:data]

      expect(merchants.count).to eq 20
      expect(merchants.first[:id]).to eq first_id.to_s
      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).is_a? String
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq 'merchant'
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).is_a? String
      end
    end

    it 'can return more merchants' do
      create_list(:merchant, 20).last.id
      create_list(:merchant, 60)

      get '/api/v1/merchants?per_page=80'

      expect(response.status).to eq 200

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchants = merchants[:data]

      expect(merchants.count).to eq 80
      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).is_a? String
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq 'merchant'
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).is_a? String
      end
    end

    it 'does not return more merchants than exist' do
      create_list(:merchant, 20).last.id
      create_list(:merchant, 60)

      get '/api/v1/merchants?per_page=500'

      expect(response.status).to eq 200

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchants = merchants[:data]

      expect(merchants.count).to eq 80
      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).is_a? String
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq 'merchant'
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).is_a? String
      end
    end
  end

  describe '#show' do
    it 'returns a given merchant' do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      expect(response.status).to eq 200

      merchant = JSON.parse(response.body, symbolize_names: true)
      merchant = merchant[:data]

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).is_a? String
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq 'merchant'
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).is_a? String
    end
  end
end