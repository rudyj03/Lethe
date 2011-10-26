class PagesController < ApplicationController
  def index
    @title = "Home"
    @item = Item.new if signed_in?
    redirect_to user_path(current_user) if signed_in?
  end

end
