require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As a Merchant Employee' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      user_2 = User.create!(name: "Hope",
                            street_address: "456 Space st",
                            city: "Space",
                            state: "CO",
                            zip: 80111,
                            email_address: "Hope@example.com",
                            password: "superEasyPZ",
                            role: 1,
                            merchant_id: @bike_shop.id)
      visit "/login"

      click_link "Log In"
      fill_in("Email Address", with: "#{user_2.email_address}")
      fill_in("Password", with: "#{user_2.password}")
      click_button("Submit")
    end

    it 'can see the merchants name and full address of the merchant' do
      visit merchant_path

      expect(page).to have_content("#{@bike_shop.name}'s Dashboard")
      within "#merchant_info" do
        expect(page).to have_content("Address: #{@bike_shop.full_address}")
      end
    end
  end
end
