require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As a Merchant Employee' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    end
    it 'can see the merchants name and full address of the merchant' do
      visit merchant_path

      expect(page).to have_content("#{@bike_shop.name}'s Dashboard")
      within "#merchant_info-#{@bike_shop.id}" do
        expect(page).to have_content("Address: #{@bike_shop.full_address}")
      end
    end
  end
end
