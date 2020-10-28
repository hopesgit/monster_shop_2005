
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end

    it "I see a link to head back to the home page" do
      visit '/merchants'

      within 'nav' do
        click_on "Home"
      end

      expect(current_path).to eq("/")

      visit '/items'

      within 'nav' do
        click_on "Home"
      end

      expect(current_path).to eq("/")
    end

    it "I see a link to see what's in my shopping cart" do
      visit '/merchants'

      within 'nav' do
        click_on "Cart"
      end

      expect(current_path).to eq("/cart")

      visit '/items'

      within 'nav' do
        click_on "Cart"
      end

      expect(current_path).to eq("/cart")
    end

    it "I see a link to log in on all pages" do
      visit '/merchants'

      within 'nav' do
        click_on "Log In"
      end

      expect(current_path).to eq("/login")

      visit '/items'

      within 'nav' do
        click_on "Log In"
      end

      expect(current_path).to eq("/login")
    end

    it "I see a link to register on all pages" do

    end
  end
end
