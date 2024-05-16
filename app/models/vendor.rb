class Vendor < ApplicationRecord
  has_many :market_vendors, dependent: :destroy
  has_many :markets, through: :market_vendors

  validates :name, presence: true
  validates :description, presence: true
  validates :contact_name, presence: true
  validates :contact_phone, presence: true
  
  validate :credit_card_response

  def credit_card_response
    errors.add(:credit_accepted, "can't be nil") if credit_accepted.nil?
  end
end