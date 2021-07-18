require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
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
  end
end