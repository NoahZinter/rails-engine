class Merchant < ApplicationRecord
  has_many :items

  def self.find_by_name(name)
    Merchant.where("lower(name) like ?", "%#{name.downcase}%").order(:name).limit(1).first
  end
end
