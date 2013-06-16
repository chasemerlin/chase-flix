class ReviewsController < ApplicationController
	before_filter :require_user

	def create 
		@video = Video.find(params[:video_id])
		@review = Review.new(params[:review])
		@review.video_id = @video.id
		@review.user_id = current_user.id
		if @review.save
			redirect_to home_path
		else
			render 'videos/show'
		end
	end
end