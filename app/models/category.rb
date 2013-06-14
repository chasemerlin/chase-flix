class Category < ActiveRecord::Base
	has_many :video_categories
	has_many :videos, through: :video_categories, order: :title

	validates :name, presence: true

	def recent_videos 
		videos.reorder("created_at DESC").limit(6)
	end
end