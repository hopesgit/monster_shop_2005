require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
    it {should belong_to :user}
  end

  describe 'instance methods' do
    before :each do
      user_1 = User.create!(name: "George",
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

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user_1.id)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: "fulfilled")
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "fulfilled")

      @order_2 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user_1.id)

      @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: "fulfilled")
      @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "fulfilled")

      @order_2.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 3)
    end

    it '#grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it "#total_order_items" do
      expect(@order_1.total_order_items).to eq(5)
    end

    it '#all_fulfilled?' do
      expect(@order_1.all_fulfilled?).to eq(true)
      expect(@order_2.all_fulfilled?).to eq(false)
    end

    it '#packaged_status' do
      expect(@order_1.status).to eq("pending")
      @order_1.packaged_status
      expect(@order_1.status).to eq("packaged")

      expect(@order_2.status).to eq("pending")
      @order_2.packaged_status
      expect(@order_2.status).to eq("pending")
    end
  end

  describe "class methods" do

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

      @order_3 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id)

      @order_3.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "fulfilled")

      @order_3.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 3, status: "fulfilled")
      @order_3.packaged_status

      @order_4 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id, status: 2)

      @order_4.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "fulfilled")

      @order_4.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 3, status: "fulfilled")

      @order_5 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_1.id, status: 3)

      @order_5.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "unfulfilled")

      @order_5.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 3, status: "unfulfilled")
    end

    it '.packaged_orders' do
      packaged = Order.packaged_orders

      test = packaged.all? {|order| order.packaged?}
      expect(test).to eq(true)
    end

    it '.pending_orders' do
      pending = Order.pending_orders

      test = pending.all? {|order| order.pending?}
      expect(test).to eq(true)
    end

    it '.shipped_orders' do
      shipped = Order.shipped_orders

      test = shipped.all? {|order| order.shipped?}
      expect(test).to eq(true)
    end

    it '.cancelled_orders' do
      cancelled = Order.cancelled_orders

      test = cancelled.all? {|order| order.cancelled?}
      expect(test).to eq(true)
    end
  end
end
