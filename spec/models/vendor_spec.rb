require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe 'relationships' do
    it { should have_many :market_vendors }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe 'validations' do
    it {  should validate_presence_of :name }
    it {  should validate_presence_of :description  }
    it {  should validate_presence_of :contact_name }
    it {  should validate_presence_of :contact_phone  }
    
    it 'validates the presence of credit_accepted' do
      valid_vendor = Vendor.new(
        name: "Valid Vendor",
        description: 'Description',
        contact_name: 'Contact Name',
        contact_phone: '123-456-7890',
        credit_accepted: true
        )
      expect(valid_vendor).to be_valid

      valid_vendor.credit_accepted = false
      expect(valid_vendor).to be_valid

      invalid_vendor = Vendor.new(
        name: "Invalid Vendor",
        description: 'Description',
        contact_name: 'Contact Name',
        contact_phone: '123-456-7890',
        credit_accepted: nil
        )
      expect(invalid_vendor).not_to be_valid
      expect(invalid_vendor.errors[:credit_accepted]).to include("can't be nil")
    end
  end

  describe 'instance methods' do
    describe 'credit_card_response' do
      it 'adds an error if credit_accepted is nil' do
        vendor = Vendor.new(
          name: "Vendor Name",
          description: 'Description',
          contact_name: 'Contact Name',
          contact_phone: '123-456-7890'
          )
        vendor.valid?
        expect(vendor.errors[:credit_accepted]).to include("can't be nil")
      end

      it 'does not add an error if credit_accepted is true or false' do
        vendor1 = Vendor.new(
          name: "Vendor Name",
          description: 'Description',
          contact_name: 'Contact Name',
          contact_phone: '123-456-7890',
          credit_accepted: true
          )
        expect(vendor1).to be_valid

        vendor2 = Vendor.new(
          name: "Vendor Name",
          description: 'Description',
          contact_name: 'Contact Name',
          contact_phone: '123-456-7890',
          credit_accepted: false
          )
        expect(vendor2).to be_valid
      end
    end
  end
end
