class MerchantNameRevenueErrorSerializer
  include JSONAPI::Serializer
  attributes :message, :errors, :status
end
