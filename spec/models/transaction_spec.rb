require 'rails_helper'

RSpec.describe Transaction do
  describe 'validations' do
    it { should belong_to(:invoice) }
  end
end
