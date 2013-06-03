require 'spec_helper'

describe Video do
	it "saves itself" do
		video = Video.new(title: "Gladiator", description: "The general who became a slave. The slave who became a gladiator. The gladiator who defied an emperor.")
		video.save
		Video.first.title.should == "Gladiator"
	end
end