class HousesController < ApplicationController
  before_action :find_house, only: [:show, :like, :dislike]

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


  def like

    # 先確認之前有沒有資料存在裡面
    like_state = current_user.like_states.find_by(likeable_id: @house.id)

    # 如果今天有資料存在裡面，有兩種狀況
    # (1) 之前有人按過倒讚，所以state是false => 因此這個我們要把它變成true
    # (2) 之前有人按過正讚，所以state是true => 因此這個我們要移除like_state
    # 如果沒有資料存在裡面，有兩種情況
    # (1) 從來沒有點過讚
    # (2) 有點過讚，但是點第二次，被刪掉了 => 兩種情況都一樣，我們要新增一個新的state: true的like_state進去
    if like_state
      if like_state.state == false
        like_state.update(state: true)
        render json: { status: 'covert dislike to liked' }
      else
        like_state.delete
        render json: { status: 'delete like_state' }
      end
    else
      current_user.like_states.create(state: true, likeable: @house)
      render json: { status: 'liked' }

    end



    # u1.like_states.new(boolean: true, likeable: h)

    # # 如果今天使用者有對這間房屋按讚 - 先抓出使用者 <-> Like 的表，查看state是不是true
    # if current_user.like_states.any? { |ele| ele.likeable_id == @house.id && ele.state == true }
    #   # 我們把state轉成false  
    #   like_state = current_user.like_states.find_by(likeable_id: @house.id)
    #   like_state.update(state: false)
    #   render json: { status: 'disliked', like_state: like_state }
    # else
    #   # 如果沒有，我們像這樣新增u1.like_states.new(boolean: true, likeable: h)，state是true
    #   # 如果曾經有資料有在裡面，只是state狀態為false的話
    #   if current_user.like_states.find_by(likeable_id: @house.id)
    #     like_state = current_user.like_states.find_by(likeable_id: @house.id)
    #     like_state.update(state: true)      
    #   else
    #     # 如果完全沒有在裡面，就直接新增一個LikeState
    #     current_user.like_states.new(state: true, likeable: @house)
    #     current_user.save
    #   end      
      
    #   render json: { status: 'liked' }
    # end
    # 我們把state轉成false

    # 如果沒有，我們像這樣新增u1.like_states.new(boolean: true, likeable: h)，state是true
    # Ps. 應該要判斷兩個，判斷一，完全沒有新增過，
    # 這樣就好 -> u1.like_states.new(boolean: true, likeable: h)
    # 如果之前有新增過，不過state: false，這樣只要找到該Like，把state轉成true就好
    
  end


  def dislike
    
    # 先確認之前有沒有資料存在裡面
    like_state = current_user.like_states.find_by(likeable_id: @house.id)
    # 如果資料在裡面的話 -> 資料已經存在有兩種情況，一種是之前就按過倒讚，所以裡面存的是state: false，按第二次，所以裡面
    if like_state
      # 資料已存在的情況下，state有兩種狀態
      # 一種是true，會是true的原因，是之前有人按正讚，所以這邊我們要改成倒讚
      # 一種是false ，會是false的原因，是因為之前有人按倒讚，所以這邊我們要把倒讚刪掉
      if like_state.state == true
        like_state.update(state: false)
        render json: { status: 'covert like to disliked' }
      else
        like_state.delete
        render json: { status: 'delete like_state' }
      end
            
    else
      # 如果沒在裡面，有兩種情況
      # 一種是之前完全沒人按過倒讚
      # 一種是之前有人按過，但把它刪掉了
      # 不過兩種情況都一樣，我們都要把他給加回來
      # 把新增一筆like_state，並且狀態是false
      current_user.like_states.create(state: false, likeable: @house)
      render json: { status: 'disliked' }
    end
    
  end
  # 直接列幾種狀況
  # (1) LikeState裡面沒有按讚/倒讚資料
  #  - 1. 可能是從來都沒有按過
  #  - 2. 之前有按過，按讚/倒讚第二次，被移除了

  # (2) LikeState裡面有按讚/倒讚資料
  #  - 1. 按讚/倒讚一次，會把資料存進來
  #  - 2. 使用者之前按過讚，接著直接按倒讚會讓發現裡面是有資料的



  private
  def find_house
    @house = House.find(params[:id])
  end


end
