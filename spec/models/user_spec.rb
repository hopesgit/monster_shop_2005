require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:street_address)}
    it {should validate_presence_of(:city)}
    it {should validate_presence_of(:state)}
    it {should validate_presence_of(:zip)}
    it {should validate_presence_of(:email_address)}
    it {should validate_uniqueness_of(:email_address)}
    it {should validate_presence_of(:password)}
    it { should have_secure_password }
  end

  describe 'relationships' do
    it {should have_many :orders}
    it { should belong_to(:merchant).optional }
  end

  describe "roles" do
    it "gets created as user by default" do
      user_2 = User.create!(name: "George",
                            street_address: "123 lane",
                            city: "Denver",
                            state: "CO",
                            zip: 80111,
                            email_address: "George@example.com",
                            password: "superEasyPZ")
      expect(user_2.role).to eq("default")
      expect(user_2.role).to_not eq("merchant")
      expect(user_2.role).to_not eq("admin")
      expect(user_2.default?).to eq(true)
      expect(user_2.merchant?).to_not eq(true)
      expect(user_2.admin?).to_not eq(true)
    end

    it "can be a merchant" do
      user_3 = User.create!(name: "Hope",
                            street_address: "222 Hope Ln",
                            city: "Denver",
                            state: "CO",
                            zip: 80112,
                            email_address: "hope@example.com",
                            password: "supersecret",
                            role: 1)
      expect(user_3.role).to eq("merchant")
      expect(user_3.role).to_not eq("default")
      expect(user_3.role).to_not eq("admin")
      expect(user_3.default?).to_not eq(true)
      expect(user_3.merchant?).to eq(true)
      expect(user_3.admin?).to_not eq(true)
    end

    it "can be an admin" do
      user_4 = User.create!(name: "Shaun",
                            street_address: "333 Shaun Ln",
                            city: "Denver",
                            state: "CO",
                            zip: 80112,
                            email_address: "shaun@example.com",
                            password: "catan",
                            role: 2)
      expect(user_4.role).to_not eq("merchant")
      expect(user_4.role).to_not eq("default")
      expect(user_4.role).to eq("admin")
      expect(user_4.default?).to_not eq(true)
      expect(user_4.merchant?).to_not eq(true)
      expect(user_4.admin?).to eq(true)
    end
  end
end
