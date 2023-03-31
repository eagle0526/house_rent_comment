module Admin
  class HousesController < ApplicationController
    before_action :authenticate_user!

    def index

      @houses = House.all

    end

    def new
      @house = current_user.houses.new
    end

    def create
      # render html: params
      @house = current_user.houses.new(params_house)

      if @house.save
        redirect_to admin_user_houses_path(current_user), notice: "成功新增房屋"
      else
        render :new
      end
    end

    private

    def params_house
      params.require(:house).permit(:title, :tel, :address, :owner)
    end

  end
end