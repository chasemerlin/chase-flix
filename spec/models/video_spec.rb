require 'spec_helper'

describe Video do
	it { should have_many(:categories).through(:video_categories) }
	it { should validate_presence_of :title }
	it { should validate_presence_of :description }

	it "saves itself" do
		video = Video.new(
			title: "Gladiator",
			description: "A general becomes a slave who becomes a gladiator.",
			small_cover_url: "/tmp/gladiator.jpg",
			large_cover_url: "/tmp/gladiator_large.jpg")
		video.save
		Video.first.title.should == "Gladiator"
	end

	it "should be valid with title, description, small_cover_url, and large_cover_url" do
		video = Video.new(
			title: "Gladiator",
			description: "A general becomes a slave who becomes a gladiator.",
			small_cover_url: "/tmp/gladiator.jpg",
			large_cover_url: "/tmp/gladiator_large.jpg")
		expect(video).to be_valid
	end

	it "should be invalid without a title" do
		video = Video.new(
			description: "A general becomes a slave who becomes a gladiator.",
			small_cover_url: "/tmp/gladiator.jpg",
			large_cover_url: "/tmp/gladiator_large.jpg")
		expect(video).to have(1).errors_on(:title)
	end

	it "should be invalid without a description" do
		video = Video.new(
			title: "Gladiator",
			small_cover_url: "/tmp/gladiator.jpg",
			large_cover_url: "/tmp/gladiator_large.jpg")
	end

	it "can have a category" do
		video = Video.new(
			title: "Gladiator",
			description: "A general becomes a slave who becomes a gladiator.",
			small_cover_url: "/tmp/gladiator.jpg",
			large_cover_url: "/tmp/gladiator_large.jpg")
		category = Category.create(name: "Drama")
		video.categories << category
		video.categories.size.should == 1
	end
end