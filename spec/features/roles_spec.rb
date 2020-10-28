require "rails_helper"

describe "At various user levels" do
  describe "As a Visitor" do
    it "gives you a 404 error if you go to these pages when not logged in" do
      allow_any_instance_of(ApplicationController).to receive(:current_user)

      visit "/merchant"
      save_and_open_page
      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/admin"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/profile"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end
end
