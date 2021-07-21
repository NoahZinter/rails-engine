class MerchantRevenueSerializer
  include JSONAPI::Serializer
  attribute :revenue do |merchant|
    merchant.total_revenue
  end
end
