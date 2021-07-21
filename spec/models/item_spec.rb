require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
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

      it 'returns empty array for nil searches' do
        id = create(:merchant).id
        create(:item, merchant_id: id, name: 'Pizza Bagels')
        create(:item, merchant_id: id, name: 'Pizza Donuts')
        create(:item, merchant_id: id, name: 'Pizza Hotdogs')

        expect(Item.find_all_by_name('corn')).is_a? Array
        expect(Item.find_all_by_name('corn')).to eq ([])
      end
    end

    describe 'top_by_revenue' do
      it 'retrieves top x items by revenue' do
        top = Item.top_by_revenue(5)
        expect(top).is_a? Array
        top.each do |item|
          expect(item).is_a? Item
          expect(item.id).is_a? Integer
          expect(item.name).is_a? String
          expect(item.description).is_a? String
          expect(item.revenue).is_a? Float
        end
        expect(top.first.revenue).to be >= top.last.revenue
      end
    end
  end
end