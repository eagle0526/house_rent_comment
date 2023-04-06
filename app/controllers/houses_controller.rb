class HousesController < ApplicationController
  before_action :find_house, only: [:show]

  def index
  end

  def create
  end


  def show

    @comment = @house.comments.new
    @comments = @house.comments.where("parent_id IS NULL OR parent_id = 0").includes(:user)

    # 這樣寫可以抓到報瓜被軟刪除掉的留言
    @all_comments = Comment.with_deleted.all
  end



  private
  def find_house
    @house = House.find(params[:id])
  end


end
