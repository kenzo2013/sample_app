class PagesController < ApplicationController
  def home
	@titre = "Home"
	if signed_in?
		@micropost = Micropost.new 
		@feed_items = current_user.feed.paginate(:page => params[:page])
	end
  end

  def contact
  	@titre = "Contact"
  end

  def about
  	@titre = "About"
  end

  def help
  	@titre = "Help"
  end
end
