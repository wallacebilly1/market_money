class Vendor < ApplicationRecord
  has_many :market_vendors, dependent: :destroy
  has_many :markets, through: :market_vendors

  validates_presence_of :name,
                        :description,
                        :contact_name,
                        :contact_phone
  validate :credit_card_response

  def credit_card_response
    errors.add(:credit_accepted, "can't be nil") if credit_accepted.nil?
  end
end