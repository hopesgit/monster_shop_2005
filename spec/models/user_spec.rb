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
      expect(user_2.default?).to eq(true)
    end
  end
end
