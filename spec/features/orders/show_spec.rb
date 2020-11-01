require 'rails_helper'

describe "As a registered user" do
  describe "When I have items in my cart and I visit it" do
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

    it "I am directed to my orders page where I see a message telling me
    my order has been created and my cart is empty" do
      expect(current_path).to eq("/profile/orders")
      expect(page).to have_content("Cart: 0")
      expect(page).to have_content("Your order has been created")
      click_link("Order ##{Order.last.id}")
      expect(page).to have_content("#{@paper.name}")
    end

    it "has a link that goes to /profile/orders/:id and more details" do
      current_order = Order.last
      click_link("Order ##{current_order.id}")
      expect(current_path).to eq("/profile/orders/#{current_order.id}")

      within("#order-details") do
        expect(page).to have_content("Order ID: #{current_order.id}")
        expect(page).to have_content("Total: $#{current_order.grandtotal}")
        expect(page).to have_content("Total Items: #{current_order.total_order_items}")
        expect(page).to have_content("Order Date: #{current_order.created_at}")
        expect(page).to have_content("Last Updated: #{current_order.updated_at}")
      end

      expect(page).to have_content(current_order.status)

      within("#item-#{@tire.id}") do
        expect(page).to have_xpath("//img[contains(@src,'#{@tire.image}')]")
        expect(page).to have_content(@tire.description)
      end

      within("#item-#{@paper.id}") do
        expect(page).to have_xpath("//img[contains(@src,'#{@paper.image}')]")
        expect(page).to have_content(@paper.description)
      end

      within("#item-#{@pencil.id}") do
        expect(page).to have_xpath("//img[contains(@src,'#{@pencil.image}')]")
        expect(page).to have_content(@pencil.description)
      end
    end

    it "can cancel orders, which brings those items back to the total" do
      current_order = Order.last
      item_1 = current_order.items[0]
      item_1_inventory_before_delete = item_1.inventory
      item_1_order_quantity = current_order.item_orders.find_by(item_id: item_1.id).quantity

      visit("/profile/orders/#{current_order.id}")

      expect(page).to have_link("Cancel Order")
      click_link("Cancel Order")

      expect(page).to have_content("The order is now cancelled.")
      expect(current_path).to eq("/profile")
      current_order.reload

      visit("/profile/orders")
      expect(current_order.status).to eq("cancelled")

      within("#order-#{current_order.id}") do
        expect("Order Status: cancelled")
      end

      current_order.item_orders.each do |item_order|
        expect(item_order.status).to eq("unfulfilled")
      end

      item_1.reload
      expect(item_1.inventory).to eq(item_1_inventory_before_delete + item_1_order_quantity)
    end
  end
end
