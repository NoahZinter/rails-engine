require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'class methods' do
    describe '.find_by_name' do
      it 'finds merchant by partial match' do
        mike = create(:merchant, name: "Mike's Big Barrels Of Ketchup")
        create_list(:merchant, 20)

        expect(Merchant.find_by_name('Mike')).to eq mike
      end

      it 'orders alphabetically' do
        later_mike = create(:merchant, name: "Mike Z Big Barrels Of Ketchup")
        mike = create(:merchant, name: "Mike A Big Barrels Of Ketchup")

        expect(Merchant.find_by_name('Mike')).to eq mike
      end

      it 'is case insensitive' do
        later_mike = create(:merchant, name: "mike Z Big Barrels Of Ketchup")
        mike = create(:merchant, name: "Mike a BiG Barrels Of Ketchup")

        expect(Merchant.find_by_name('mike')).to eq mike
        expect(Merchant.find_by_name('mIKE')).to eq mike
      end
    end

    describe 'top_merchants_by_revenue' do
      it 'returns top earning merchants' do
        top_merchants = Merchant.top_merchants_by_revenue(5)

        first_revenue = top_merchants.first.revenue
        last_revenue = top_merchants.last.revenue

        expect(top_merchants).is_a? Array
        expect(top_merchants.length).to be <= 5
        expect(top_merchants.first).is_a? Merchant
        expect(top_merchants.first.revenue).is_a? Float
        expect(first_revenue).to be >= last_revenue
      end
    end
  end

  describe 'instance methods' do
    describe 'total revenue' do
      it 'returns total revenue' do
        merch = Merchant.top_merchants_by_revenue(1).first
        expect(merch).is_a? Merchant
        expect(merch.total_revenue).to eq merch.revenue
      end
    end
  end
end