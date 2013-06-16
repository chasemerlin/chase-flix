class VideosController < ApplicationController
	before_filter :require_user

	def index
		@videos = Video.all
		@categories = Category.all
	end

	def show
		@video = Video.find(params[:id])
		@reviews = @video.reviews
		@review = Review.new
	end

	def search
		search_term = params[:term]
		@videos = Video.search_by_title(search_term)
	end
end