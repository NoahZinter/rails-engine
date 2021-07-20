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
      before(:all) do
        merchants = []
        20.times do merchants << Merchant.create!(name: Faker::Company.name)
        end
        merchant_ids = merchants.map{|merchant| merchant.id }
        merchants.each do |merchant|
          10.times{ merchant.items.create!( name: Faker::Commerce.product_name, description: Faker::Lorem.sentence, unit_price: Faker::Commerce.price )}
        end
        customers = []
        20.times { customers << Customer.create!(first_name: Faker::Games::StreetFighter.character, last_name: Faker::Games::ElderScrolls.last_name)}
        customer_ids = customers.map { |customer| customer.id}
        invoices = []
        20.times { invoices << Invoice.create!(customer_id: customer_ids.sample, merchant_id: merchant_ids.sample, status: ['shipped', 'pending', 'cancelled'].sample)}
        invoices.each do |invoice|
          10.times{ invoice.transactions.create!(credit_card_number: Faker::Business.credit_card_number, credit_card_expiration_date: Faker::Business.credit_card_expiry_date, result: ['success', 'failed'].sample)}
        end
        invoice_ids = invoices.map { |invoice| invoice.id }
        item_ids = merchants.map {|merchant| merchant.items.map{|item| item.id}}.flatten!
        invoice_items = []
        20.times { invoice_items << InvoiceItem.create!(item_id: item_ids.sample, invoice_id: invoice_ids.sample, quantity: Faker::Number.within(range: 2..20), unit_price: Faker::Commerce.price )}
      end
      it 'returns top earning merchants' do
        top_merchants = Merchant.top_merchants_by_revenue(5)
        first_revenue = top_merchants.first.revenue
        last_revenue = top_merchants.last.revenue

        expect(top_merchants).is_a? Array
        expect(top_merchants.length).to eq 5
        expect(top_merchants.first).is_a? Merchant
        expect(top_merchants.first.revenue).is_a? Float
        expect(first_revenue).to be >= last_revenue
      end
    end
  end
end