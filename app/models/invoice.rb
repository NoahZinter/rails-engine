class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  def self.pending_revenue
    joins(:transactions, :invoice_items)
    .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as potential_revenue')
    .where('invoices.status = ?', 'pending')
    .where('transactions.result = ?', 'success')
    .group(:id)
  end
end
