class CommentsController < ApplicationController
  before_action :find_house, only: [:create]
  before_action :find_comment, only: [:destroy]
#   before_action :find_comment, only: [:show, :edit, :update, :destroy, :destroy_image]

  
  def create
    @content = params[:content]
    @parent = params[:parent_id].to_i
    @comment = current_user.comments.new(content: @content, house_id: @house.id, parent_id: @parent)
            
    if @comment.save
      redirect_to house_path(@house), notice: "成功新增留言"
    else      
      render html: '失敗增加留言'
    end

  end


  def edit
    
  end

  def destroy
    # render html: params
    @comment.destroy
    redirect_to house_path(@comment.house_id), alert: "成功刪除留言"
  end

  private

  def find_house
    @house = House.find(params[:id])
  end

  # def params_comment
  #   params.require(:comment).permit(:content).merge(house: @house)
  # end

  def find_comment
    @comment = Comment.find(params[:id])
  end



end
