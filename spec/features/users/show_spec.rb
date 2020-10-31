require 'rails_helper'


describe 'User Show Page' do
  describe 'As a registered user' do
    it "can see all its profile date minus my password" do
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
      fill_in("Password", with: "#{user_2.password}")
      click_button("Submit")

      expect(page).to have_content("Name: #{user_2.name}")
      expect(page).to have_content("Street Address: #{user_2.street_address}")
      expect(page).to have_content("City: #{user_2.city}")
      expect(page).to have_content("State: #{user_2.state}")
      expect(page).to have_content("Zip: #{user_2.zip}")
      expect(page).to have_content("Email: #{user_2.email_address}")
      expect(page).to_not have_content(user_2.password)

      expect(page).to have_link('Edit Profile')
    end
  end
end
