class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  def self.find_all_by_name(name)
    Item.where("lower(name) like ?", "%#{name.downcase}%").order(:name)
  end
end
