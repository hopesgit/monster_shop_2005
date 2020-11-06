require 'rails_helper'

describe "As a user" do
  describe "I see my orders listed on my profile/orders page" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @user_1 = User.create!(name: "George",
                            street_address: "123 lane",
                            city: "Denver",
                            state: "CO",
                            zip: 80111,
                            email_address: "George@example.com",
                            password: "superEasyPZ")

      visit "/login"

      click_link "Log In"
      fill_in("Email Address", with: "#{@user_1.email_address}")
      fill_in("Password", with: "#{@user_1.password}")
      click_button("Submit")

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      visit '/cart'
      click_link "Checkout"

      fill_in(:name, with: @user_1.name)
      fill_in(:address, with: @user_1.street_address)
      fill_in(:city, with: @user_1.city)
      fill_in(:state, with: @user_1.state)
      fill_in(:zip, with: @user_1.zip)

      click_button("Create Order")
    end

    it "When I click create order it takes me to my profile/orders page" do
      expect(current_path).to eq('/profile/orders')
      expect(page).to have_content("#{@user_1.name}'s orders")
      expect(page).to have_content("Cart: 0")
      expect(page).to have_content("Your order has been created")
    end

    it "has the order details" do
      current_order = Order.last

      expect(page).to have_link("Order ##{current_order.id}")
      expect(page).to have_content("Order Date: #{current_order.created_at.localtime.strftime("%m/%d/%y")}")
      expect(page).to have_content("Last Updated: #{current_order.updated_at.localtime.strftime("%m/%d/%y")}")
      expect(page).to have_content("Order Status: #{current_order.status}")
      expect(page).to have_content("Total Items: #{current_order.total_order_items}")
      expect(page).to have_content("Grand Total: $#{current_order.grandtotal}")
    end
  end
end
