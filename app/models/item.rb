class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  def self.find_all_by_name(name)
    Item.where("lower(name) like ?", "%#{name.downcase}%").order(:name)
  end

  def self.top_by_revenue(quantity)
    joins(invoices: :transactions)
    .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .where('transactions.result = ?', 'success')
    .group(:id)
    .order('revenue desc')
    .limit(quantity)
  end
end
