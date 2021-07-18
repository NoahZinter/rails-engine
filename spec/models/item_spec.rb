require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'class methods' do
    describe 'find_all_by_name' do
      it 'finds all by name' do
        id = create(:merchant).id
        create(:item, merchant_id: id, name: 'Pizza Bagels')
        create(:item, merchant_id: id, name: 'Pizza Donuts')
        create(:item, merchant_id: id, name: 'Pizza Hotdogs')
        create(:item, merchant_id: id, name: 'Pizza Curry')
        create(:item, merchant_id: id, name: 'Pizza Toast')
        create(:item, merchant_id: id, name: 'Pizza Cake')
        create(:item, merchant_id: id, name: 'Pizza Muffin')
        create(:item, merchant_id: id, name: 'Pizza Soda')
        salad = create(:item, merchant_id: id, name: 'Salad')
        arugula = create(:item, merchant_id: id, name: 'Arugula')
        grains = create(:item, merchant_id: id, name: 'Grains')

        expect(Item.find_all_by_name('pizza')).is_a? Array
        expect((Item.find_all_by_name('pizza')).count).to eq 8
        expect((Item.find_all_by_name('pizza')).include?(salad)).to eq false
        expect((Item.find_all_by_name('pizza')).include?(arugula)).to eq false
        expect((Item.find_all_by_name('pizza')).include?(grains)).to eq false
      end
    end

    it 'returns empty array for nil searches' do
        id = create(:merchant).id
        create(:item, merchant_id: id, name: 'Pizza Bagels')
        create(:item, merchant_id: id, name: 'Pizza Donuts')
        create(:item, merchant_id: id, name: 'Pizza Hotdogs')

        expect(Item.find_all_by_name('corn')).is_a? Array
        expect(Item.find_all_by_name('corn')).to eq ([])
    end
  end
end