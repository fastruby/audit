class HomeController < ApplicationController
  def index
    @file = Gemfile.new
  end

  def privacy
  end
end
