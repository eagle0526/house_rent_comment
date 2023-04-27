module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :find_user, only: [:destroy_image]


    def show
      # @houses = current_user.houses
      message = params[:query]

      if message == "已留言"
        @houses = current_user.comments.uniq(&:house_id).map { |comment| House.find_by(id: comment.house_id) }
      elsif message == "已點讚"
        @houses = current_user.like_states.house_state_true.map { |like| House.find_by(id: like.likeable_id) }
      elsif message == "已瀏覽"
        @houses = current_user.page_views.where(impressionable_type: "House").pluck(:impressionable_id).uniq.map { |view| House.find_by(id: view) }
      else
        @houses = current_user.houses
      end




      # render html: message
    end

    def edit          
      
    end


    def update
    #   render html: params
      if current_user.update(params_user)
        redirect_to edit_admin_user_path(current_user.id), notice: "成功更新使用者資料"
      else
        render :edit, status: :unprocessable_entity
      end
      
    end

    def destroy_image      

      @user.avatar.purge
      redirect_to edit_admin_user_path(@user.id), alert: "成功刪除圖片"      
    end

    private

    def params_user
      params.require(:user).permit(:name, :avatar)
    end


    def find_user
      @user = User.find(params[:id])
    end
  end
end