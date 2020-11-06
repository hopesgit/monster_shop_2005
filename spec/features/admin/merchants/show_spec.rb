require 'rails_helper'

describe 'As an Admin' do
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
    fill_in("Email Address", with: "#{@user_3.email_address}")
    fill_in("Password", with: "#{@user_3.password}")
    click_button("Submit")
  end

  it 'can click on any merchants name and be routed to that unique merchants dashboard page and I can do all the functions of a merchant' do
    visit '/admin/merchants'
    expect(page).to have_link("#{@bike_shop.name}")
    click_on "#{@bike_shop.name}"

    expect(current_path).to eq("/admin/merchants/#{@bike_shop.id}")
    # expect(current_path).to eq(admin_merchant_path(@bike_shop.id))

    expect(page).to have_content(@order_1.id)
    # expect(page).to have_content(@pencil.name)
  end
end
