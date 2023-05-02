import { Controller } from "@hotwired/stimulus"
import { fetchWithoutParams } from "../controllers/lib/fetcher"
import { dispatchAction } from "../controllers/lib/dispatch"

export default class extends Controller {

  static targets = [ 'thumbsUp', "thumbsDown", "commentLikeCount", "commentDislikeCount" ]

  initialize(){    
    
  }
  connect() {    

    const commentLikeState = this.element.dataset.commentLikeState
    if (commentLikeState === 'true') {
      // 如果是正讚，讓正讚是solid，倒讚是regular
      this.likeButtonSolid()
      this.dislikeButtonRegular()

    } else if (commentLikeState === 'false') {
      this.dislikeButtonSolid()
      this.likeButtonRegular()
    }
    
  }

  like() {        

    const commentId = this.element.dataset.commentId
    const userId = this.element.dataset.currentUserId

    if (userId === 'Logged out') {
      dispatchAction("popup")
    } else {
      fetchWithoutParams(`/comments/${commentId}/like`, "PATCH")
      .then(({status, likeCommentCount, dislikeCommentCount}) => {
        if (status === "liked comment") {
          this.likeButtonSolid()
        } else if (status === "delete comment like_state") {        
          this.likeButtonRegular()
        } else {
          // 倒讚Regular        
          this.dislikeButtonRegular()
          // 正讚Solid
          this.likeButtonSolid()
        }
  
        this.setTextContent(likeCommentCount, dislikeCommentCount)
      })
      .catch((err) => {
        console.log(err);
      })
    }
  }

  dislike() {        

    const commentId = this.element.dataset.commentId
    const userId = this.element.dataset.currentUserId

    if (userId === 'Logged out') {
      dispatchAction("popup")
    } else {
      fetchWithoutParams(`/comments/${commentId}/dislike`, "PATCH")
      .then(({status, likeCommentCount, dislikeCommentCount}) => {

        if (status === "disliked comment") {
          this.dislikeButtonSolid()
        } else if (status === "delete comment like_state") {        
          this.dislikeButtonRegular()
        } else {
          // 正讚Regular
          this.likeButtonRegular()
          // 倒讚Solid
          this.dislikeButtonSolid()
        }
  
        this.setTextContent(likeCommentCount, dislikeCommentCount)

      })
      .catch((err) => {
        console.log(err);
      })
    }
  }

  likeButtonSolid() {
    this.thumbsUpTarget.classList.add("fa-solid")
    this.thumbsUpTarget.classList.remove("fa-regular")
  }

  likeButtonRegular() {
   this.thumbsUpTarget.classList.remove("fa-solid")
   this.thumbsUpTarget.classList.add("fa-regular")
  }

  dislikeButtonSolid() {
    this.thumbsDownTarget.classList.add("fa-solid")
    this.thumbsDownTarget.classList.remove("fa-regular")
  }

  dislikeButtonRegular(){
    this.thumbsDownTarget.classList.add("fa-regular")
    this.thumbsDownTarget.classList.remove("fa-solid")
  }



  setTextContent(likeCommentCount, dislikeCommentCount) {
    this.commentLikeCountTarget.textContent = likeCommentCount
    this.commentDislikeCountTarget.textContent = dislikeCommentCount
  }



}

