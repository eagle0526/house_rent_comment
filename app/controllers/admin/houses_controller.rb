module Admin
  class HousesController < ApplicationController
    before_action :authenticate_user!
    before_action :find_hosue, only: [:show, :edit, :update, :destroy]
    # before_action :params_house, only: [:create, :update]

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

    def show
    end

    def edit

    end

    def update
      if @house.update(params_house)
        redirect_to admin_house_path(@house), notice: "成功編輯房屋"
      else
        render :edit
      end
    end

    def destroy
      @house.destroy
      redirect_to admin_user_houses_path(current_user), alert: "成功刪除房屋"
    end

    def destroy_image
      # render html: params
      @house = House.find_by(id: params[:house_id])
      @house.images.find(params[:image_id]).purge
      redirect_to edit_admin_house_path(@house), alert: "成功刪除圖片"

    end

    private

    def params_house
      params.require(:house).permit(:title, :description, :tel, :address, :owner, images: [])
    end

    def find_hosue
      @house = House.find(params[:id])
    end

  end
end