class HomeController < ApplicationController
  def index
    # @houses = House.all    
    @pagy, @houses = pagy(House.all, items: 3)
  end
end
  