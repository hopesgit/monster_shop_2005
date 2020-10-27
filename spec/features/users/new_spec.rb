require "rails_helper"

describe "as a vistor" do
  describe "user new page" do
    it "has a register link in the nav bar" do
      visit '/merchants'

      expect(page).to have_link('Register')
      click_link 'Register'
      expect(current_path).to eq('/register')
    end

    it "has a form asking for new user details" do
      visit '/register'

      expect(page).to have_field("Name")
      expect(page).to have_field("Street Address")
      expect(page).to have_field("City")
      expect(page).to have_field("State")
      expect(page).to have_field("Zip Code")
      expect(page).to have_field("Email Address")
      expect(page).to have_field("Password")
      expect(page).to have_field("Confirm Password")
    end

    it "has a form asking for new user details" do
      visit '/register'

      fill_in "Name", with: "Mike Dao"
      fill_in "Street Address", with: "100 Main"
      fill_in "City", with: "Denver"
      fill_in "State", with: "CO"
      fill_in "Zip", with: "80002"
      fill_in "Email Address", with: "mike@gmail"
      fill_in "Password", with: "password"
      fill_in "Confirm Password", with: "password"

      click_button "Submit"

      expect(current_path).to eq('/profile')
    end
  end
end
