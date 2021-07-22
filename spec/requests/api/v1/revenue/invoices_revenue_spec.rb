require 'rails_helper'

RSpec.describe 'Invoice Revenue Requests' do
  describe 'unshipped' do
    it 'returns potential revenue of unshipped invoices' do
      get '/api/v1/revenue/unshipped?quantity=2'

      expect(response.status).to eq 200
    end
  end
end