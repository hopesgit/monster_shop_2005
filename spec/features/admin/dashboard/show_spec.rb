require "rails_helper"

describe "As an Admin user" do
  describe "When I visit my dashboard" do

    before :each do
      @user_1 = User.create!(name: "George",
                            street_address: "123 lane",
                            city: "Denver",
                            state: "CO",
                            zip: 80111,
                            email_address: "George@example.com",
                            password: "superEasyPZ")

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: "fulfilled")
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "fulfilled")

      @order_2 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id)

      @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: "fulfilled")
      @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "fulfilled")

      @order_2.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 3)

      @user_3 = User.create!(name: "Todd",
                            street_address: "789 Main st",
                            city: "Denver",
                            state: "CO",
                            zip: 80111,
                            email_address: "Todd@example.com",
                            password: "superEasyPZ",
                            role: 2)

      visit("/login")
      click_link "Log In"
      fill_in("Email Address", with: "#{@user_3.email_address}")
      fill_in("Password", with: "#{@user_3.password}")
      click_button("Submit")
    end

    it "has a list of orders in the system, sorted by status, and reports user who placed the order, the order id, and create date" do
      visit admin_path

      within("#pending-orders") do
        within("#order-#{@order_1.id}") do
          expect(page).to have_content("User name: #{@order_1.user.name}")
          expect(page).to have_link(@order_1.user.name)
          expect(page).to have_content("Order ID: #{@order_1.id}")
          expect(page).to have_content("Date created: #{@order_1.created_at}")
        end
      end

      within("#pending-orders") do
        within("#order-#{@order_2.id}") do
          expect(page).to have_content("User name: #{@order_2.user.name}")
          expect(page).to have_link(@order_2.user.name)
          expect(page).to have_content("Order ID: #{@order_2.id}")
          expect(page).to have_content("Date created: #{@order_2.created_at}")
          click_link(@order_2.user.name)
        end
      end

      expect(current_path).to eq("/admin/users/#{@order_2.user_id}")
    end

    it "the orders are sorted by status (packaged, then pending, then shipped, then cancelled)" do
      expect(page.all("section")[0]).to have_content("Packaged Orders:")
      expect(page.all("section")[1]).to have_content("Pending Orders:")
      expect(page.all("section")[2]).to have_content("Order ID:")
      expect(page.all("section")[4]).to have_content("Shipped Orders:")
      expect(page.all("section")[5]).to have_content("Cancelled Orders:")
    end
  end
end
