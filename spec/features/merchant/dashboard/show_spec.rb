require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As a Merchant Employee' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pencil = @bike_shop.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @user_2 = User.create!(name: "Hope",
                            street_address: "456 Space st",
                            city: "Space",
                            state: "CO",
                            zip: 80111,
                            email_address: "Hope@example.com",
                            password: "superEasyPZ",
                            role: 1,
                            merchant_id: @bike_shop.id)
      @order_1 = Order.create!(name: "George",
        address: "123 lane",
        city: "Denver",
        state: "CO",
        zip: 80111,
        user_id: @user_2.id)
      @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: "5", status: "fulfilled")
      @order_1.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: "20", status: "fulfilled")
      visit "/login"

      click_link "Log In"
      fill_in("Email Address", with: "#{@user_2.email_address}")
      fill_in("Password", with: "#{@user_2.password}")
      click_button("Submit")
    end

    it 'can see the merchants name and full address of the merchant' do
      visit '/merchant'

      expect(page).to have_content("#{@bike_shop.name}'s Dashboard")
      within "#merchant_info" do
        expect(page).to have_content("Address: #{@bike_shop.full_address}")
      end
    end

    it 'can see the pending orders that I sell. I will see a list that includes: link of order_id, date of order, total quantity, and total value of the order' do
      test = @order_1.grandtotal
      visit "/merchant"

      expect(page).to have_content('Pending Orders:')
      within "#order-#{@order_1.id}" do
        expect(page).to have_link(@order_1.id)
        expect(page).to have_content(@order_1.created_at.localtime.strftime("%m/%d/%y"))
        expect(page).to have_content(@order_1.total_order_items)
        expect(page).to have_content(test)
        click_link "#{@order_1.id}"

      end

      expect(current_path).to eq(merchant_order_path(@order_1))
    end

    it 'can see a link to all of the items I have for sale' do
      visit "/merchant"

      expect(page).to have_link('My Items')
      click_link 'My Items'
      expect(current_path).to eq(merchant_items_path(@user_2.merchant_id))

      within "#item-#{@tire.id}" do
        expect(page).to have_content("Name: #{@tire.name}")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_content("Name: #{@pencil.name}")
      end
    end
  end
end
