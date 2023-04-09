class HousesController < ApplicationController
  before_action :find_house, only: [:show, :like, :dislike]

  def index
  end

  def create
  end


  def show

    @comment = @house.comments.new
    @comments = @house.comments.where("parent_id IS NULL OR parent_id = 0").includes(:user)

    @good = 123
    

  end


  def like

    # 先確認之前有沒有資料存在裡面
    # house_like_state = current_user.like_states.find_by(likeable_type: "House", likeable_id: @house.id)
    house_like_state = current_user.house_like_state(@house.id)
    
    
    # 如果今天有資料存在裡面，有兩種狀況
    # (1) 之前有人按過倒讚，所以state是false => 因此這個我們要把它變成true
    # (2) 之前有人按過正讚，所以state是true => 因此這個我們要移除like_state
    # 如果沒有資料存在裡面，有兩種情況
    # (1) 從來沒有點過讚
    # (2) 有點過讚，但是點第二次，被刪掉了 => 兩種情況都一樣，我們要新增一個新的state: true的like_state進去

    if house_like_state
      if house_like_state.state == true
        house_like_state.delete    
        render json: { status: 'delete house like_state' }
      else
        house_like_state.update(state: true)        
        render json: { status: 'covert comment dislike to liked' }
      end
    else
      current_user.like_states.create(state: true, likeable: @house)      
      render json: { status: 'liked house' }
    end    
  end


  def dislike
    
    # 先確認之前有沒有資料存在裡面
    # like_state = current_user.like_states.find_by(likeable_type: "House", likeable_id: @house.id)
    like_state = current_user.house_like_state(@house.id)
    # 如果資料在裡面的話 -> 資料已經存在有兩種情況，一種是之前就按過倒讚，所以裡面存的是state: false，按第二次，所以裡面
    if like_state
      # 資料已存在的情況下，state有兩種狀態
      # 一種是true，會是true的原因，是之前有人按正讚，所以這邊我們要改成倒讚
      # 一種是false ，會是false的原因，是因為之前有人按倒讚，所以這邊我們要把倒讚刪掉
      if like_state.state == false
        like_state.delete
        render json: { status: 'delete house like_state' }
      else
        like_state.update(state: false)
        render json: { status: 'covert house like to disliked' }
      end
            
    else
      # 如果沒在裡面，有兩種情況
      # 一種是之前完全沒人按過倒讚
      # 一種是之前有人按過，但把它刪掉了
      # 不過兩種情況都一樣，我們都要把他給加回來
      # 把新增一筆like_state，並且狀態是false
      current_user.like_states.create(state: false, likeable: @house)
      render json: { status: 'disliked houses' }
    end
    
  end

  private
  def find_house
    @house = House.find(params[:id])
  end


end
