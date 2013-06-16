class Video < ActiveRecord::Base
	has_many :video_categories
	has_many :categories, through: :video_categories, order: :name

	has_many :reviews, order: "created_at DESC"

	validates :title, presence: true
	validates :description, presence: true

	def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def average_rating
  	if !reviews.any?
  		0
  	else
  		ratings = []
  		reviews.each { |review| ratings << review.rating }
  		(ratings.inject { |sum, el| sum + el }.to_f / ratings.size).round(1)
  	end
  end
end