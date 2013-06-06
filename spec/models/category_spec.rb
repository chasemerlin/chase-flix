require 'spec_helper'

describe Category do
	it { should have_many(:videos).through(:video_categories) }
	it { should validate_presence_of :name }

	it "should be valid with a name" do
		category = Category.new(name: "Romance")
		expect(category).to be_valid
	end

	it "should be invalid without a name" do
		category = Category.new()
		expect(category).to have(1).errors_on(:name)
	end

	it "can have many videos" do
		category = Category.create(name: "Action")
		south_park = Video.create(title: "South Park", description: "Funny kids")
		gladiator = Video.create(title: "Gladiator", description: "The general who became a slave who became a gladiator.")
		category.videos << south_park
		category.videos << gladiator
		expect(category.videos).to eq([gladiator, south_park])
	end
end