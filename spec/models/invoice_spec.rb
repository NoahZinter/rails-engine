require 'rails_helper'

RSpec.describe Invoice do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end

  describe 'class methods' do
    describe 'pending revenue' do
      it 'finds total potential revenue of pending invoices' do
        invoices = Invoice.pending_revenue(5)
        expect(invoices).is_a? Array
        expect(invoices.length).to be <= 5
        expect(invoices.first.potential_revenue).to be >= invoices.last.potential_revenue
        invoices.each do |invoice|
          expect(invoice.id).is_a? Integer
          expect(invoice.customer_id).is_a? Integer
          expect(invoice.merchant_id).is_a? Integer
          expect(invoice.status).to eq 'pending'
          expect(invoice.potential_revenue).is_a? Float
        end
      end
    end
  end
end