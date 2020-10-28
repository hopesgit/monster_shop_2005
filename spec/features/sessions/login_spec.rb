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
                            password: "superEasyPZ")
      visit "/login"

      click_link "Log In"
      fill_in("Email Address", with: "#{user_2.email_address}")
      fill_in("Password", with: "#{user_2.password}")
      click_button("Submit")

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Logged in as #{user_2.name}.")
    end
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
end
