class StaticPagesController < ApplicationController
  def home
  	@micropost = Micropost.new
  	@feed_items = current_user.microposts.paginate(page: params[:page])
  end

  def help
  end

  def about
  end

  def contacts
  end
end
