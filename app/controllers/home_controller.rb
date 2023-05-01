class HomeController < ApplicationController
  def index
    # @houses = House.all    
    @pagy, @houses = pagy(House.all, items: 3)


    p "*" * 50
    p @pagy.next
    p @houses
    p "*" * 50

  end
end
  