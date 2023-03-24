module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def edit          
      
    end


    def update
    #   render html: params
      if current_user.update(params_user)
        redirect_to edit_admin_user_path(current_user.id), notice: "成功更新暱稱"
      else
        render :edit
      end
      
    end

    private

    def params_user
      params.require(:user).permit(:nickname)
    end
  end
end