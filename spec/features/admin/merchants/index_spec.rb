require 'rails_helper'

describe "As an Admin" do
  describe "When I visit the merchant index (/admin/merchants)" do
    before :each do
      @user_3 = User.create!(name: "Todd",
                            street_address: "789 Main st",
                            city: "Denver",
                            state: "CO",
                            zip: 80111,
                            email_address: "Todd@example.com",
                            password: "superEasyPZ",
                            role: 2)
      @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pencil = @bike_shop.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/login"

      click_link "Log In"
      fill_in("Email Address", with: "#{@user_3.email_address}")
      fill_in("Password", with: "#{@user_3.password}")
      click_button("Submit")
    end
    it "has a disable button that, when clicked, disables a merchant account and flashes a message telling me this" do
      visit "/admin/merchants"
      expect(@bike_shop.active?).to eq(true)
      expect(@tire.active?).to eq(true)
      expect(@pencil.active?).to eq(true)

      within("#merchant-#{@bike_shop.id}") do
        expect(page).to have_button("Disable")
        click_button("Disable")
      end

      @bike_shop.reload
      @tire.reload
      @pencil.reload
      expect(@bike_shop.active?).to eq(false)
      expect(page).to have_content("Merchant disabled.")
      expect(@tire.active?).to eq(false)
      expect(@pencil.active?).to eq(false)

      within("#merchant-#{@bike_shop.id}") do
        expect(page).to have_button("Enable")
        click_button("Enable")
      end

      @bike_shop.reload
      @tire.reload
      @pencil.reload

      expect(@bike_shop.active?).to eq(true)
      expect(page).to have_content("Merchant re-enabled.")
      expect(@tire.active?).to eq(true)
      expect(@pencil.active?).to eq(true)
    end
  end
end
