class CommentsController < ApplicationController
  before_action :find_house, only: [:create]
  before_action :find_comment, only: [:edit, :update, :destroy]

  
  def create    
    @comment = current_user.comments.new(params_comment)
            
    if @comment.save
      redirect_to house_path(@house), notice: "成功新增留言"
    else      
      redirect_to house_path(@house), alert: "留言失敗，至少要五個字"
    end
  end

  def edit
    @house = @comment.house_id
  end

  def update
    @content = params[:comment][:content]    
    if @comment.update(content: @content)      
      redirect_to house_path(@comment.house_id), notice: "成功編輯留言"
    else
      render :edit
    end
  end

  def destroy    
    @comment.destroy
    redirect_to house_path(@comment.house_id), alert: "成功刪除留言"
  end

  private

  def find_house
    @house = House.find(params[:id])
  end

  def params_comment
    params.require(:comment).permit(:content).merge(house: @house, parent_id: params[:parent_id])
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end



end
