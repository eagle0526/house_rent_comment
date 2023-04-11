class CommentsController < ApplicationController
  before_action :find_house, only: [:create]
  before_action :find_comment, only: [:edit, :update, :destroy, :like, :dislike]

  
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

  def like        
    # 先確定有沒有在資料庫裡面
    # comment_like_state = current_user.like_states.find_by(likeable_type: "Comment", likeable_id: @comment.id)
    comment_like_state = current_user.comment_like_state(@comment.id)
    
    # 計算喜歡和不喜歡的數量
    like_comment_count = @comment.like_states.comment_true_count
    dislike_comment_count = @comment.like_states.comment_false_count

    # 如果有在裡面，代表兩件事
    # (1) 之前有人對該則留言按過讚 state: true -> 之後我們要把該則留言刪掉
    # (2) 之前有人對此留言按過倒讚 state: false -> 我們要把該則留言的倒讚轉成正讚
    # 如果沒有在裡面，代表兩件事
    # (1) 從來沒有人對這個按鈕按過讚
    # (2) 之前有人對他按過讚，但是按了第二次 -> 都是要新增一個狀態為true的Likestate
    if comment_like_state

      if comment_like_state.state == true
        comment_like_state.delete
        render json: { status: 'delete comment like_state', likeCommentCount: like_comment_count-1, dislikeCommentCount: dislike_comment_count }
      else
        comment_like_state.update(state: true)
        render json: { status: 'covert comment disliked to liked', likeCommentCount: like_comment_count+1, dislikeCommentCount: dislike_comment_count-1 }
      end
    else
      current_user.like_states.create(state: true, likeable: @comment)
      render json: { status: 'liked comment', likeCommentCount: like_comment_count+1, dislikeCommentCount: dislike_comment_count }
    end



  end


  def dislike
    # 先確定有沒有在資料庫裡面
    # comment_like_state = current_user.like_states.find_by(likeable_type: "Comment", likeable_id: @comment.id)
    comment_like_state = current_user.comment_like_state(@comment.id)

    # 計算喜歡和不喜歡的數量
    like_comment_count = @comment.like_states.comment_true_count
    dislike_comment_count = @comment.like_states.comment_false_count

    # 如果有在裡面，代表兩件事
    # (1) 之前有人對該則留言按過倒讚 state: false -> 之後我們要把該則留言刪掉
    # (2) 之前有人對此留言按過正讚 state: true -> 我們要把該則留言的正讚轉成倒讚
    # 如果沒有在裡面，代表兩件事
    # (1) 從來沒有人對這個按鈕按過倒讚
    # (2) 之前有人對他按過倒讚，但是按了第二次 -> 都是要新增一個狀態為false的Likestate

    if comment_like_state
      if comment_like_state.state == false
        comment_like_state.delete
        render json: { status: 'delete comment like_state', likeCommentCount: like_comment_count, dislikeCommentCount: dislike_comment_count-1 }
      else
        comment_like_state.update(state: false)
        render json: { status: 'covert comment liked to disliked', likeCommentCount: like_comment_count-1, dislikeCommentCount: dislike_comment_count+1 }
      end
    else
      current_user.like_states.create(state: false, likeable: @comment)
      render json: { status: 'disliked comment', likeCommentCount: like_comment_count, dislikeCommentCount: dislike_comment_count+1 }
    end
    
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

