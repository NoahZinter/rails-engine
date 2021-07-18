class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_all_by_name(name)
    Item.where("lower(name) like ?", "%#{name.downcase}%").order(:name)
  end
end
