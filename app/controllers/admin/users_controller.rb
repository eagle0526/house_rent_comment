module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :find_user, only: [:destroy_image]


    def show

      @message = params[:query]

      @houses = case @message
                when "已留言"
                  current_user.comments_ordered_by_time
                when "已點讚"
                  current_user.liked_ordered_by_time
                when "已瀏覽"
                  current_user.viewed_ordered_by_time
                else
                  current_user.published_ordered_by_time
                end
      
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