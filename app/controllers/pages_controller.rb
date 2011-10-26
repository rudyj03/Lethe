class PagesController < ApplicationController
  def index
    @title = "Home"
    @item = Item.new if signed_in?
  end

end
