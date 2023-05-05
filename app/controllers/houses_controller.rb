class HousesController < ApplicationController
  before_action :find_house, only: [:show, :like, :dislike]
  

  def index
    # @pagy, @houses = pagy(House.search_by_address(params[:keyword]), items: 4)
    houses = if params[:title]
               House.search_by_title(params[:title])
             elsif params[:street]
               House.search_by_address(params[:street])
             else
               House.order_by_time
             end

    @pagy, @houses = pagy(houses, items: 4)


  end

  def create
  end


  def show

    @comment = @house.comments.new
    @comments = @house.root_full_comments

    # 喜歡房子的數量    
    @liked_houses_count = @house.like_states.house_true_count
    # 不喜歡房子的數量    
    @disliked_houses_count = @house.like_states.house_false_count

    # 計算瀏覽次數
    impressionist(@house)


    # 找出是哪些人點房子讚
    @user_click_nice_to_house = @house.like_states.house_state_true.each.map { |like| User.find_by(id: like.user_id) }    
  end


  def like

    # 先確認之前有沒有資料存在裡面
    # house_like_state = current_user.like_states.find_by(likeable_type: "House", likeable_id: @house.id)
    house_like_state = current_user.house_like_state(@house.id)


    # 喜歡的數量
    @liked_houses_count = @house.like_states.select { |like| like.state }.size
    # 不喜歡的數量
    @disliked_houses_count = @house.like_states.size - @house.like_states.select { |like| like.state }.size


    if house_like_state
      if house_like_state.state == true
        house_like_state.delete            
        render json: { status: 'delete house like_state', houseLikeCount: @liked_houses_count-1, houseDislikeCount: @disliked_houses_count }
      else
        house_like_state.update(state: true)                
        render json: { status: 'covert house dislike to liked', houseLikeCount: @liked_houses_count+1, houseDislikeCount: @disliked_houses_count-1 }
      end
    else
      current_user.like_states.create(state: true, likeable: @house)            
      render json: { status: 'liked house', houseLikeCount: @liked_houses_count+1, houseDislikeCount: @disliked_houses_count }
    end    
  end


  def dislike
    
    # 先確認之前有沒有資料存在裡面
    like_state = current_user.house_like_state(@house.id)

    # 喜歡的數量
    @liked_houses_count = @house.like_states.select { |like| like.state }.size
    # 不喜歡的數量
    @disliked_houses_count = @house.like_states.size - @house.like_states.select { |like| like.state }.size

    if like_state
      if like_state.state == false
        like_state.delete
        render json: { status: 'delete house like_state', houseLikeCount: @liked_houses_count, houseDislikeCount: @disliked_houses_count-1 }
      else
        like_state.update(state: false)
        render json: { status: 'covert house like to disliked', houseLikeCount: @liked_houses_count-1, houseDislikeCount: @disliked_houses_count+1}
      end
            
    else
      current_user.like_states.create(state: false, likeable: @house)
      render json: { status: 'disliked houses', houseLikeCount: @liked_houses_count, houseDislikeCount: @disliked_houses_count+1 }
    end
    
  end


  private
  def find_house
    @house = House.find(params[:id])
  end


end
