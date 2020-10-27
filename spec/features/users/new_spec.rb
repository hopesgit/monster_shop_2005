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
  end
end
