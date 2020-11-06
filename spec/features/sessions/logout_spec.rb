require 'rails_helper'

RSpec.describe 'Logout' do
  describe 'When I visit the logout path' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @user_3 = User.create!(name: "Hope",
                            street_address: "222 Hope Ln",
                            city: "Denver",
                            state: "CO",
                            zip: 80112,
                            email_address: "hope@example.com",
                            password: "supersecret",
                            role: 1,
                            merchant_id: @bike_shop.id)
      visit "/login"

      click_link "Log In"
      fill_in("Email Address", with: "#{@user_3.email_address}")
      fill_in("Password", with: @user_3.password)
      click_button("Submit")

    end
    it 'can get redirected to the home page' do
      visit '/items'
      click_link 'Log Out'

      expect(current_path).to eq('/')
      expect(page).to have_content('You are logged out!')
    end


  end
end
