class UnshippedOrderSerializer
  include JSONAPI::Serializer
  attribute :potential_revenue do |invoice|
    invoice.potential_revenue
  end
end
