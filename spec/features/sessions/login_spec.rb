require "rails_helper"

describe "As a User" do
  describe "when I try to log in" do
    it "I give it the correct credentials and it logs me in" do

      user_2 = User.create!(name: "George",
                            street_address: "123 lane",
                            city: "Denver",
                            state: "CO",
                            zip: 80111,
                            email_address: "George@example.com",
                            password: "superEasyPZ",
                            merchant_id: @bike_shop.id)
      visit "/login"

      click_link "Log In"
      fill_in("Email Address", with: "#{user_2.email_address}")
      fill_in("Password", with: "#{user_2.password}")
      click_button("Submit")

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Logged in as #{user_2.name}.")
    end

    it "I give it the wrong credentials and it doesn't log me in" do
      user_2 = User.create!(name: "George",
                            street_address: "123 lane",
                            city: "Denver",
                            state: "CO",
                            zip: 80111,
                            email_address: "George@example.com",
                            password: "superEasyPZ")
      visit "/login"

      click_link "Log In"
      fill_in("Email Address", with: "#{user_2.email_address}")
      fill_in("Password", with: "Vote4Hope")
      click_button("Submit")

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Incorrect email/password combination.")
    end

    it 'will be redirected to the profile page' do
      user_2 = User.create!(name: "George",
                            street_address: "123 lane",
                            city: "Denver",
                            state: "CO",
                            zip: 80111,
                            email_address: "George@example.com",
                            password: "superEasyPZ")
      visit "/login"

      click_link "Log In"
      fill_in("Email Address", with: "#{user_2.email_address}")
      fill_in("Password", with: user_2.password)
      click_button("Submit")

      visit '/login'
      expect(page).to have_current_path('/profile')
      expect(page).to have_content('You are already logged in!')
    end
  end

  describe 'As a merchant' do
    it 'can get redirected to the merchants dashboard' do
      user_3 = User.create!(name: "Hope",
                            street_address: "222 Hope Ln",
                            city: "Denver",
                            state: "CO",
                            zip: 80112,
                            email_address: "hope1@example.com",
                            password: "supersecret",
                            role: 1)
      visit "/login"

      fill_in("Email Address", with: "#{user_3.email_address}")
      fill_in("Password", with: "#{user_3.password}")
      click_on "Submit"

      expect(current_path).to eq('/merchant')
    end

    it 'will be redirected to the profile page' do
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

      click_link "Log In"
      fill_in("Email Address", with: "#{user_3.email_address}")
      fill_in("Password", with: user_3.password)
      click_button("Submit")

      visit '/login'

      expect(page).to have_current_path('/merchant')
      expect(page).to have_content('You are already logged in!')
    end
  end
  describe 'As a admin' do
    it 'can get redirected to the admins dashboard' do
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

      expect(current_path).to eq('/admin')
    end
  end
end
