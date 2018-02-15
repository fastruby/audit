class HomeController < ApplicationController
  def index
    @file = Gemfile.new
  end
end
