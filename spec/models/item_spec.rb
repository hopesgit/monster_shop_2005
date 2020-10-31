require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      user_1 = User.create!(name: "George",
                            street_address: "123 lane",
                            city: "Denver",
                            state: "CO",
                            zip: 80111,
                            email_address: "George@example.com",
                            password: "superEasyPZ")

      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @pumpkin_treat = @brian.items.create( name: "Pumpkin Treat", description: "Seasonal Favorite!", price: 11, image: "https://i.imgur.com/Lx9LqbQb.jpg", inventory: 5)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @frisbee = @meg.items.create(name: "frisbee", description: "Outdoor fun", price: 9, image: "https://i.imgur.com/10pHPwhb.jpg", inventory: 12)
      @cat_condo = @brian.items.create(name: "Cat Condo", description: "Fun for all cats", price: 100, image: "https://i.imgur.com/axlOQjQb.jpg", inventory: 45)
      @piggy_ears = @meg.items.create(name: "Piggy Ears", description: "Delish treat!", price: 24, image: "https://i.imgur.com/kV1oKJLb.jpg", inventory: 98)
      @himalayan_salt_lamp = @meg.items.create(name: "Himalayan Salt Lamp", description: "Soothing comfort", price: 72, image: "https://i.imgur.com/FuZ6ENsb.jpg", inventory: 97)
      @dream_catcher = @meg.items.create(name: "Dream Catcher", description: "Good for catching dreams!", price: 62, image: "https://i.imgur.com/FBbRiL4b.jpg", inventory: 73)

      @order_1 = Order.create!(name: 'Mike Dao', address: '1234 Main St.', city: 'Vancuver', state: 'WA', zip: 92838, user_id: user_1.id)
      @order_2 = Order.create!(name: 'Leslie Knope', address: '1234 Main St.', city: 'Chicago', state: 'IL', zip: 93847, user_id: user_1.id)
      @order_3 = Order.create!(name: 'Michelle Hershey', address: '1234 Main St.', city: 'Boston', state: 'MA', zip: 83749, user_id: user_1.id)
      @order_4 = Order.create!(name: 'Nicole Isle', address: '1234 Main St.', city: 'Jacksonville', state: 'FL', zip: 76354, user_id: user_1.id)
      @order_5 = Order.create!(name: 'Ameen Larry', address: '1234 Main St.', city: 'Casper', state: 'WY', zip: 36459, user_id: user_1.id)

      @item_order_1 = ItemOrder.create!(order_id: @order_5.id, item_id: @himalayan_salt_lamp.id, price: 72, quantity: 20)
      @item_order_2 = ItemOrder.create!(order_id: @order_4.id, item_id: @frisbee.id, price: 9, quantity: 9)
      @item_order_3 = ItemOrder.create!(order_id: @order_3.id, item_id: @cat_condo.id, price: 100, quantity: 4)
      @item_order_4 = ItemOrder.create!(order_id: @order_2.id, item_id: @pumpkin_treat.id, price: 11, quantity: 31)
      @item_order_5 = ItemOrder.create!(order_id: @order_2.id, item_id: @tire.id, price: 100, quantity: 100)
      @item_order_6 = ItemOrder.create!(order_id: @order_4.id, item_id: @tire.id, price: 100, quantity: 1)
      @item_order_7 = ItemOrder.create!(order_id: @order_3.id, item_id: @tire.id, price: 100, quantity: 7)
      @item_order_8 = ItemOrder.create!(order_id: @order_3.id, item_id: @dream_catcher.id, price: 62, quantity: 5)
      @item_order_9 = ItemOrder.create!(order_id: @order_1.id, item_id: @pull_toy.id, price: 10, quantity: 2)
      @item_order_10 = ItemOrder.create!(order_id: @order_5.id, item_id: @piggy_ears.id, price: 100, quantity: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      user_1 = User.create!(name: "George",
                            street_address: "123 lane",
                            city: "Denver",
                            state: "CO",
                            zip: 80111,
                            email_address: "George123@example.com",
                            password: "superEasyPZ")

      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user_1.id)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'finds top five' do
      expected = [@item_order_5.item, @item_order_4.item, @item_order_1.item, @item_order_2.item, @item_order_8.item]
      expect(Item.top_five).to eq(expected)
    end

    it 'finds bottom five' do
      expected = [@item_order_9.item, @item_order_10.item, @item_order_3.item, @item_order_8.item, @item_order_2.item]
      expect(Item.bottom_five).to eq(expected)
    end
  end
end
