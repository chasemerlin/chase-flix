require 'spec_helper'

describe Category do
  it { should have_many(:videos).through(:video_categories) }
  it { should validate_presence_of :name }

  describe "#recent_videos" do
     it "returns the videos in the reverse chronological order by created_at" do
      comedies = Category.create(name: "comedies")
      futurama = Video.create(title: "Futurama", description: "space travel!", created_at: 1.day.ago)
      south_park = Video.create(title: "South Park", description: "crazy kids!")
      comedies.videos << futurama
      comedies.videos << south_park
      expect(comedies.recent_videos).to eq([south_park, futurama])
    end

    it "returns all the videos if there are less than 6 videos" do
      comedies = Category.create(name: "comedies")
      futurama = Video.create(title: "Futurama", description: "space travel!", created_at: 1.day.ago)
      south_park = Video.create(title: "South Park", description: "crazy kids!")
      comedies.videos << futurama
      comedies.videos << south_park
      expect(comedies.recent_videos.count).to eq(2)
    end

    it "returns 6 videos if there are more than 6 videos" do
      comedies = Category.create(name: "comedies")
      7.times do
       video = Video.create(title: "foo", description: "bar")
       comedies.videos << video
     end
      expect(comedies.recent_videos.count).to eq(6)
    end

    it "returns the most recent 6 videos" do
      comedies = Category.create(name: "comedies")
      tonights_show = Video.create(title: "Tonights show", description: "talk show", created_at: 1.day.ago)
      comedies.videos << tonights_show
      6.times do 
        video = Video.create(title: "foo", description: "bar")
        comedies.videos << video
      end
      expect(comedies.recent_videos).not_to include(tonights_show)
    end

    it "returns an empty array if the category does not have any videos" do
      comedies = Category.create(name: "comedies")
      expect(comedies.recent_videos).to eq([])     
    end
  end

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