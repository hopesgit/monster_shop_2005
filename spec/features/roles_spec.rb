require "rails_helper"

describe "At various user levels" do
  describe "As a Visitor" do
    it "gives you a 404 error if you go to these pages when not logged in" do
      allow_any_instance_of(ApplicationController).to receive(:current_user)

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
      user_2 = User.create!(name: "George",
                            street_address: "123 lane",
                            city: "Denver",
                            state: "CO",
                            zip: 80111,
                            email_address: "Todd@example.com",
                            password: "superEasyPZ")

      visit "/items"
      click_link "Log In"
      fill_in("Email Address", with: "#{user_2.email_address}")
      fill_in("Password", with: "#{user_2.password}")
      click_button("Submit")

      allow_any_instance_of(ApplicationController).to receive(:current_user)

      visit "/merchant"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")

      visit "/admin"

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end
end
