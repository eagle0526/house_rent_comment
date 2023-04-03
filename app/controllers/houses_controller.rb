class HousesController < ApplicationController
  before_action :find_house, only: [:show]

  def index
  end

  def create
  end


  def show
    # render html: params
  end


  private
  def find_house
    @house = House.find(params[:id])
  end


end
