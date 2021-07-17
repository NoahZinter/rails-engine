require 'rails_helper'

RSpec.describe 'Items Requests' do
  describe '#index' do
    it 'lists all items, 20 per page' do
      merch_id = create(:merchant).id
      merch_id_2 = create(:merchant).id
      last_item_id = create_list(:item, 20, merchant_id: merch_id).last.id
      create_list(:item, 30, merchant_id: merch_id_2)

      get '/api/v1/items'

      expect(response.status).to eq 200

      items = JSON.parse(response.body, symbolize_names: true)
      items = items[:data]

      expect(items.count).to eq 20
      expect(items.last[:id]).to eq last_item_id.to_s
      items.each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).is_a? String
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).is_a? String
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).is_a? Float
        expect(item[:attributes]).not_to have_key(:merchant_id)
      end
    end

    it 'lists the next 20 items' do
      merch_id = create(:merchant).id
      merch_id_2 = create(:merchant).id
      create_list(:item, 20, merchant_id: merch_id)
      first_item_id = create_list(:item, 30, merchant_id: merch_id_2).first.id

      get '/api/v1/items?page=1'

      expect(response.status).to eq 200

      items = JSON.parse(response.body, symbolize_names: true)
      items = items[:data]
      expect(items.count).to eq 20
      expect(items.first[:id]).to eq first_item_id.to_s
      items.each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).is_a? String
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).is_a? String
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).is_a? Float
        expect(item[:attributes]).not_to have_key(:merchant_id)
      end
    end

    it 'can list more than 20 if directed' do
      merch_id = create(:merchant).id
      merch_id_2 = create(:merchant).id
      create_list(:item, 20, merchant_id: merch_id).last.id
      create_list(:item, 30, merchant_id: merch_id_2)

      get '/api/v1/items?per_page=50'

      expect(response.status).to eq 200

      items = JSON.parse(response.body, symbolize_names: true)
      items = items[:data]

      expect(items.count).to eq 50
      items.each do |item|
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).is_a? String
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).is_a? String
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).is_a? Float
        expect(item[:attributes]).not_to have_key(:merchant_id)
      end
    end
  end

  describe '#show' do
    # Test 404 response for item which doesn't exist
    it 'returns info for given item' do
      merch_id = create(:merchant).id
      items_list = create_list(:item, 20, merchant_id: merch_id)
      item_id = items_list.last.id

      get "/api/v1/items/#{item_id}"

      expect(response.status).to eq 200

      item = JSON.parse(response.body, symbolize_names: true)
      item = item[:data]

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).is_a? String
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).is_a? String
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).is_a? Float
      expect(item[:attributes]).not_to have_key(:merchant_id)
    end
  end

  describe '#create' do
    it 'creates an item' do
      merch_id = create(:merchant).id
      item_params = {
        name: 'Weak Leather Hose',
        description: 'Excellent Hoseyness',
        unit_price: 50.67,
        merchant_id: merch_id
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response.status).to eq 200
      expect(created_item.name).to eq 'Weak Leather Hose'
      expect(created_item.description).to eq 'Excellent Hoseyness'
      expect(created_item.unit_price).to eq 50.67
      expect(created_item.merchant_id).to eq merch_id
    end

    it 'ignores extra attributes' do
      merch_id = create(:merchant).id
      item_params = {
        name: 'Weak Leather Hose',
        description: 'Excellent Hoseyness',
        unit_price: 50.67,
        merchant_id: merch_id,
        nonsense: 'Horsefeathers'
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response.status).to eq 200
      expect(created_item.name).to eq 'Weak Leather Hose'
      expect(created_item.description).to eq 'Excellent Hoseyness'
      expect(created_item.unit_price).to eq 50.67
      expect(created_item.merchant_id).to eq merch_id
      expect{created_item.nonsense}.to raise_error(NoMethodError)
    end

    it 'does not create with missing attributes' do
      merch_id = create(:merchant).id
      create(:item, merchant_id: merch_id)
      item_params = {
        name: 'Weak Leather Hose',
        description: 'Excellent Hoseyness',
        unit_price: 50.67
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response.status).to eq 400
      expect(created_item.name).not_to eq 'Weak Leather Hose'
      expect(created_item.description).not_to eq 'Excellent Hoseyness'
      expect(created_item.unit_price).not_to eq 50.67
    end
  end

  describe '#update' do
    it 'can edit all fields of an item' do
      merch_id = create(:merchant).id
      original_item = create(:item, merchant_id: merch_id)
      item_params = {
        name: 'Weak Leather Hose',
        description: 'Excellent Hoseyness',
        unit_price: 50.67
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      patch "/api/v1/items/#{original_item.id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find(original_item.id)

      expect(response.status).to eq 200
      expect(item.name).not_to eq original_item.name
      expect(item.name).to eq 'Weak Leather Hose'
      expect(item.description).not_to eq original_item.description
      expect(item.description).to eq 'Excellent Hoseyness'
      expect(item.unit_price).not_to eq original_item.unit_price
      expect(item.unit_price).to eq 50.67
    end

    it 'can edit just the name' do
      merch_id = create(:merchant).id
      original_item = create(:item, merchant_id: merch_id)
      item_params = {
        name: 'Weak Leather Hose'
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      patch "/api/v1/items/#{original_item.id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find(original_item.id)

      expect(response.status).to eq 200
      expect(item.name).not_to eq original_item.name
      expect(item.name).to eq 'Weak Leather Hose'
      expect(item.description).to eq original_item.description
      expect(item.unit_price).to eq original_item.unit_price
    end

    it 'does not edit extra attributes' do
      merch_id = create(:merchant).id
      original_item = create(:item, merchant_id: merch_id)
      item_params = {
        name: 'Weak Leather Hose',
        nonsense: 'Poppycock'
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      patch "/api/v1/items/#{original_item.id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find(original_item.id)

      expect(response.status).to eq 200
      expect(item.name).not_to eq original_item.name
      expect(item.name).to eq 'Weak Leather Hose'
      expect(item.description).to eq original_item.description
      expect(item.unit_price).to eq original_item.unit_price
      expect{item.nonsense}.to raise_error(NoMethodError)
    end
    # Explicitly test and render 404 for not found item to edit?
  end

  describe '#destroy' do
    it 'deletes an item' do
      merch_id = create(:merchant).id
      items_list = create_list(:item, 20, merchant_id: merch_id)
      item_id = items_list.last.id

      expect(Item.count).to eq 20

      delete "/api/v1/items/#{item_id}"

      expect(response.status).to eq 204
      expect(Item.count).to eq 19
      expect{Item.find(item_id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end