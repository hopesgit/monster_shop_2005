require "rails_helper"

describe "as a vistor" do
  describe "user new page" do
    it "has a register link in the nav bar" do
      visit '/merchants'

      expect(page).to have_link('Register')
      click_link 'Register'
      expect(current_path).to eq('/register')
    end
  end
end
