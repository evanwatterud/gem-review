require 'rails_helper'

feature 'user adds a review to a beer' do
  before(:each) do
    @beer = FactoryGirl.create(:beer)
  end

  scenario 'authenticated user adds a review to a beer' do
    ActionMailer::Base.deliveries.clear
    user = log_in
    visit beer_path(@beer)
    @beer.update_attributes(user: user)

    fill_in "review_body", with: 'something'
    click_button 'Add Review'

    expect(current_path).to eq(beer_path(@beer))
    expect(page).to have_button('Add Review')
    expect(@beer.reviews.length).to eq(1)
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  scenario 'authenticated user tries to add a blank review' do
    user = log_in
    visit beer_path(@beer)

    click_button 'Add Review'

    expect(current_path).to eq(beer_reviews_path(@beer))
    expect(page).to have_content("can't be blank")
    expect(@beer.reviews.length).to eq(0)
  end

  scenario 'unauthenticated user can not add reviews' do
    visit beer_path(@beer)

    expect(page).to have_button('Add Review', disabled: true)
    expect(page).to have_field('review_body', disabled: true)
    within('.review_box') do
      expect(page).to have_content('Log in to add reviews')
    end

    page.driver.submit :post, beer_reviews_path(@beer), {}
    expect(page).to have_content('You must be logged in to do that')
    expect(current_path).to eq('/users/sign_in')
  end
end
