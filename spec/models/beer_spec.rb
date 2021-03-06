require 'rails_helper'

RSpec.describe Beer, type: :model do
  it { should have_valid(:name).when('Beer', 'Coors Light') }
  it { should_not have_valid(:name).when(nil, '') }

  it { should have_valid(:user_id).when(1) }
  it { should_not have_valid(:user_id).when(nil) }

  it { should have_valid(:brewer).when('Beer', 'Coors Light') }
  it { should_not have_valid(:brewer).when(nil, '') }

  it { should have_valid(:style).when('Beer', 'Coors Light') }
  it { should_not have_valid(:style).when(nil, '') }

  it { should have_valid(:brewing_country).when('Beer', 'Coors Light') }
  it { should_not have_valid(:brewing_country).when(nil, '') }

  it { should have_valid(:abv).when(1, 2.3) }
  it { should_not have_valid(:abv).when(nil, '', 'letters', -1, -3.3, -134, 332.2) }

  it "has a unique name" do
    beer1 = FactoryGirl.create(:beer)
    beer2 = FactoryGirl.create(:beer)
    beer2.name = beer1.name

    expect(beer2).to_not be_valid
    expect(beer2.errors[:name]).to_not be_blank
  end

  it "has a user" do
    user = FactoryGirl.create(:user)
    beer = FactoryGirl.create(:beer)

    beer.user_id = user.id

    expect(beer.user).to eq(user)
  end

  describe "#search" do
    before(:each) do
      @coors = FactoryGirl.create(:beer, name: 'Coors')
      @jameson = FactoryGirl.create(:beer, name: 'Jameson')
    end

    it 'gets all beers when no search given' do
      expect(Beer.search.length).to eq(2)
    end

    it 'gets correct beer when name is searched' do
      expect(Beer.search('Jameson').first).to eq(@jameson)
    end

    it 'gets beers when they start with search letter' do
      jim_beam =FactoryGirl.create(:beer, name: 'Jim Beam')
      expect(Beer.search('J')).to eq([@jameson, jim_beam])
    end
  end
end
