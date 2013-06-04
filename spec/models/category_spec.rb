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
		category = Category.new(name: "Action")
		category.videos << Video.new
		category.videos << Video.new
		expect(category.videos.size).to eq 2
	end
end