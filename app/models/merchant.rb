class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  def self.find_by_name(name)
    Merchant.where("lower(name) like ?", "%#{name.downcase}%").order(:name).limit(1).first
  end

  def self.top_merchants_by_revenue(limit)
    joins(invoice_items: :invoice)
    .joins(:transactions)
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .where('transactions.result = ?', 'success')
    .group(:id)
    .order('revenue desc')
    .limit(limit)
  end

  def total_revenue
    invoice_items.joins(invoice: :transactions)
    .where('transactions.result = ?', 'success')
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
