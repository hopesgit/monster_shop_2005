require "rails_helper"

describe "At various user levels" do
  describe "As a Visitor" do
    it "gives you a 404 error if you go to these pages when not logged in" do

      visit "/merchant"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/admin"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/profile"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

  describe "As a User" do
    it "gives you a 404 error when going to these pages" do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      user_2 = User.create!(name: "George",
                            street_address: "123 lane",
                            city: "Denver",
                            state: "CO",
                            zip: 80111,
                            email_address: "Todd@example.com",
                            password: "superEasyPZ",
                            merchant_id: @mike.id)

      visit "/items"
      click_link "Log In"
      fill_in("Email Address", with: "#{user_2.email_address}")
      fill_in("Password", with: "#{user_2.password}")
      click_button("Submit")

      visit "/merchant"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/admin"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

  describe "As a Merchant" do
    it "it can't access admin links" do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      user_3 = User.create!(name: "Hope",
                            street_address: "222 Hope Ln",
                            city: "Denver",
                            state: "CO",
                            zip: 80112,
                            email_address: "hope@example.com",
                            password: "supersecret",
                            role: 1,
                            merchant_id: @bike_shop.id)
      visit "/login"

      fill_in("Email Address", with: "#{user_3.email_address}")
      fill_in("Password", with: "#{user_3.password}")
      click_on "Submit"

      visit "/admin"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

  describe "As an Admin" do
    it "can't access merchant links or the cart" do
      user_4 = User.create!(name: "Todd",
                            street_address: "999 Nine Ln",
                            city: "Denver",
                            state: "CO",
                            zip: 80112,
                            email_address: "todd2@example.com",
                            password: "abcd",
                            role: 2)
      visit "/login"

      fill_in("Email Address", with: "#{user_4.email_address}")
      fill_in("Password", with: "#{user_4.password}")
      click_on "Submit"

      visit "/merchant"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/cart"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end
end
