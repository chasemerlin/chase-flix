require 'spec_helper'

describe Video do
	it { should have_many(:categories).through(:video_categories) }
	it { should validate_presence_of :title }
	it { should validate_presence_of :description }

	describe "search_by_title" do
    it "returns an empty array if there is no match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel!")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel!")
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel!")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel!")
      expect(Video.search_by_title("Futurama")).to eq([futurama])
    end

    it "returns an array of one video for a partial match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel!")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel!")
      expect(Video.search_by_title("urama")).to eq([futurama])
    end

    it "returns an array of all matches ordered by created_at" do
      futurama = Video.create(title: "Futurama", description: "Space Travel!", created_at: 1.day.ago)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel!")
      expect(Video.search_by_title("Futur")).to eq([back_to_future, futurama])
    end

    it "returns an empty array for a search with an empty string" do
      futurama = Video.create(title: "Futurama", description: "Space Travel!", created_at: 1.day.ago)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel!")
      expect(Video.search_by_title("")).to eq([])
    end
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
		expect(video).to have(1).errors_on(:description)
	end

	it "can have a category" do
		video = Video.create(
			title: "Gladiator",
			description: "A general becomes a slave who becomes a gladiator.",
			small_cover_url: "/tmp/gladiator.jpg",
			large_cover_url: "/tmp/gladiator_large.jpg")
		category = Category.create(name: "Drama")
		video.categories << category
		expect(video.categories).to eq([category])
	end
end