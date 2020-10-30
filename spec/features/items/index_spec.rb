require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(
        name: "Meg's Bike Shop",
        address: '123 Bike Rd.',
        city: 'Denver',
        state: 'CO',
        zip: 80203)

      @brian = Merchant.create(
        name: "Brian's Dog Shop",
        address: '125 Doggo St.',
        city: 'Denver',
        state: 'CO',
        zip: 80210)

      @tire = @meg.items.create(
        name: "Gatorskins",
        description: "They'll never pop!",
        price: 100,
        image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588",
        inventory: 12)

      @pull_toy = @brian.items.create(
        name: "Pull Toy",
        description: "Great pull toy!",
        price: 10,
        image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg",
        inventory: 32)

      @pumpkin_treat = @brian.items.create(
        name: "Pumpkin Treat",
        description: "Seasonal Favorite!",
        price: 11,
        image: "https://i.imgur.com/Lx9LqbQb.jpg",
        inventory: 5)

      @frisbee = @meg.items.create(
        name: "frisbee",
        description: "Outdoor fun",
        price: 9,
        image: "https://i.imgur.com/10pHPwhb.jpg",
        inventory: 12)

      @cat_condo = @brian.items.create(
        name: "Cat Condo",
        description: "Fun for all cats",
        price: 100,
        image: "https://i.imgur.com/axlOQjQb.jpg",
        inventory: 45)

      @piggy_ears = @meg.items.create(
        name: "Piggy Ears",
        description: "Soothing comfort",
        price: 24,
        image: "https://i.imgur.com/kV1oKJLb.jpg",
        inventory: 98)

      @himalayan_salt_lamp = @meg.items.create(
        name: "Himalayan Salt Lamp",
        description: "Soothing comfort",
        price: 72,
        image: "https://i.imgur.com/FuZ6ENsb.jpg",
        inventory: 98)

      @dream_catcher = @meg.items.create(
        name: "Dream Catcher",
        description: "Good for catching dreams",
        price: 62,
        image: "https://i.imgur.com/FBbRiL4b.jpg",
        inventory: 73)

      @dog_bone = @brian.items.create(
        name: "Dog Bone",
        description: "They'll love it!",
        price: 21,
        image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg",
        active?:false,
        inventory: 21)

      @order_1 = Order.create!(
        name: 'Mike Dao',
        address: '1234 Main St.',
        city: 'Vancuver',
        state: 'WA',
        zip: 92838
      )
      @order_2 = Order.create!(
        name: 'Leslie Knope',
        address: '1234 Main St.',
        city: 'Chicago',
        state: 'IL',
        zip: 93847
      )
      @order_3 = Order.create!(
        name: 'Michelle Hershey',
        address: '1234 Main St.',
        city: 'Boston',
        state: 'MA',
        zip: 83749
      )
      @order_4 = Order.create!(
        name: 'Nicole Isle',
        address: '1234 Main St.',
        city: 'Jacksonville',
        state: 'FL',
        zip: 76354
      )
      @order_5 = Order.create!(
        name: 'Ameen Larry',
        address: '1234 Main St.',
        city: 'Casper',
        state: 'WY',
        zip: 36459
      )
      @item_order_1 = ItemOrder.create!(
        order_id: @order_5.id,
        item_id: @himalayan_salt_lamp.id,
        price: 72,
        quantity: 20,
      )
      @item_order_2 = ItemOrder.create!(
        order_id: @order_4.id,
        item_id: @frisbee.id,
        price: 9,
        quantity: 9,
      )
      @item_order_3 = ItemOrder.create!(
        order_id: @order_3.id,
        item_id: @cat_condo.id,
        price: 100,
        quantity: 5,
      )
      @item_order_4 = ItemOrder.create!(
        order_id: @order_2.id,
        item_id: @pumpkin_treat.id,
        price: 11,
        quantity: 31,
      )
      @item_order_5 = ItemOrder.create!(
        order_id: @order_2.id,
        item_id: @tire.id,
        price: 100,
        quantity: 100,
      )
      @item_order_6 = ItemOrder.create!(
        order_id: @order_4.id,
        item_id: @tire.id,
        price: 100,
        quantity: 1,
      )
      @item_order_7 = ItemOrder.create!(
        order_id: @order_3.id,
        item_id: @tire.id,
        price: 100,
        quantity: 7,
      )
      @item_order_8 = ItemOrder.create!(
        order_id: @order_3.id,
        item_id: @dream_catcher.id,
        price: 62,
        quantity: 5,
      )
      @item_order_9 = ItemOrder.create!(
        order_id: @order_1.id,
        item_id: @pull_toy.id,
        price: 10,
        quantity: 2,
      )
      @item_order_10 = ItemOrder.create!(
        order_id: @order_5.id,
        item_id: @piggy_ears.id,
        price: 100,
        quantity: 3,
      )
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to have_link(@dog_bone.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content("Inactive")
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")

    end

    it 'see all active items on the page' do
      visit '/items'

      expect(page).to_not have_content(@dog_bone.name)
    end

    it 'can use a image as a link to that particular item' do
      visit '/items'

      find(:xpath, "//a/img[@alt='#{@tire.name}-image']/..").click
      expect(current_path).to eq("/items/#{@tire.id}")

      visit '/items'
      find(:xpath, "//a/img[@alt='#{@pull_toy.name}-image']/..").click
      expect(current_path).to eq("/items/#{@pull_toy.id}")
    end

    it 'has a stats section with the top five most/least popular items' do
      visit '/items'

      within '#stats' do
        expect(page).to have_content('Top Five Most Popular Items')
        expect(page).to have_content("1. #{@tire.name} Quantity: (#{item_order_5.quantity})")
        expect(page).to have_content("2. #{@pumpkin_treat.name} Quantity: (#{item_order_4.quantity})")
        expect(page).to have_content("3. #{@himalayan_salt_lamp.name} Quantity: (#{item_order_1.quantity})")
        expect(page).to have_content("4. #{@frisbee.name} Quantity: (#{item_order_2.quantity})")
        expect(page).to have_content("5. #{@cat_condo.name} Quantity: (#{item_order_3.quantity})")

        expect(page).to have_content('Five Least Popular Items')
        expect(page).to have_content("1. #{@pull_toy.name} Quantity: (#{item_order_9.quantity})")
        expect(page).to have_content("2. #{@piggy_ears.name} Quantity: (#{item_order_10.quantity})")
        expect(page).to have_content("3. #{@dream_catcher.name} Quantity: (#{item_order_8.quantity})")
        expect(page).to have_content("4. #{@frisbee.name} Quantity: (#{item_order_2.quantity})")
        expect(page).to have_content("5. #{@pumpkin_treat.name} Quantity: (#{item_order_4.quantity})")
      end
    end
  end
end
