
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end

    it "I see a link to head back to the home page" do
      visit '/merchants'

      within 'nav' do
        click_on "Home"
      end

      expect(current_path).to eq("/")

      visit '/items'

      within 'nav' do
        click_on "Home"
      end

      expect(current_path).to eq("/")
    end

    it "I see a link to see what's in my shopping cart" do
      visit '/merchants'

      within 'nav' do
        click_on "Cart"
      end

      expect(current_path).to eq("/cart")

      visit '/items'

      within 'nav' do
        click_on "Cart"
      end

      expect(current_path).to eq("/cart")
    end

    it "I see a link to log in on all pages" do
      visit '/merchants'

      within 'nav' do
        click_on "Log In"
      end

      expect(current_path).to eq("/login")

      visit '/items'

      within 'nav' do
        click_on "Log In"
      end

      expect(current_path).to eq("/login")
    end

    it "I see a link to register on all pages" do
      visit '/merchants'

      within 'nav' do
        click_on "Register"
      end

      expect(current_path).to eq("/register")

      visit '/items'

      within 'nav' do
        click_on "Register"
      end

      expect(current_path).to eq("/register")
    end
  end

  describe "As a User" do
    before :each do
      @user = User.create(name: "George",
                          street_address: "123 lane",
                          city: "Denver",
                          state: "CO",
                          zip: 80111,
                          email_address: "Todd@example.com",
                          password: "superEasyPZ")
    end

    it "Has same links as a visitor, without login or register" do
      visit "/login"

      fill_in "Email Address", with: "#{@user.email_address}"
      fill_in "Password", with: "#{@user.password}"
      click_on "Submit"

      within 'nav' do
        expect(page).to have_link("Home")
        expect(page).to have_link("Items")
        expect(page).to have_link("Merchants")
        expect(page).to have_link("Cart")
        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
      end
    end

    it "Has same links as visitor, with logout and profile" do
      visit "/login"

      fill_in "Email Address", with: "#{@user.email_address}"
      fill_in "Password", with: "#{@user.password}"
      click_on "Submit"

      visit '/merchants'

      within 'nav' do
        expect(page).to have_link("Profile")
        click_link "Profile"
      end

      expect(current_path).to eq("/profile")

      visit '/items'

      within 'nav' do
        expect(page).to have_link("Profile")
        click_link "Profile"
      end

      expect(current_path).to eq("/profile")
    end
  end

  describe "As a merchant" do
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

      fill_in("Email Address", with: "#{@user_3.email_address}")
      fill_in("Password", with: "#{@user_3.password}")
      click_on "Submit"
    end

    it "has the User links plus a link to the merchant dashboard" do
      visit "/items"

      expect(page).to have_link("Home")
      expect(page).to have_link("Items")
      expect(page).to have_link("Merchants")
      expect(page).to have_link("Cart")
      expect(page).to have_link("Log Out")
      expect(page).to have_link("Profile")
      expect(page).to have_link("Dashboard")
    end

    it "clicking the Dashboard link brings me to /merchant" do
      visit "/items"
      click_link "Dashboard"

      expect(current_path).to eq("/merchant")
    end
  end

  describe "As an Admin" do
    before :each do
      @user_4 = User.create!(name: "Todd",
                            street_address: "999 Nine Ln",
                            city: "Denver",
                            state: "CO",
                            zip: 80112,
                            email_address: "todd2@example.com",
                            password: "abcd",
                            role: 2)
      visit "/login"

      fill_in("Email Address", with: "#{@user_4.email_address}")
      fill_in("Password", with: "#{@user_4.password}")
      click_on "Submit"
    end

    it "has this stuff" do
      visit "/items"

      expect(page).to have_link("Home")
      expect(page).to have_link("Items")
      expect(page).to have_link("Merchants")
      expect(page).to_not have_link("Cart")
      expect(page).to have_link("Log Out")
      expect(page).to have_link("Profile")
      expect(page).to have_link("Dashboard")
      expect(page).to have_link("All Users")
    end

    it "has an admin dashboard" do
      visit "/"

      click_link "Dashboard"

      expect(current_path).to eq("/admin")
    end

    it "can see a list of all users" do
      visit "/"

      click_link "All Users"

      expect(current_path).to eq("/admin/users")
    end
  end
end
