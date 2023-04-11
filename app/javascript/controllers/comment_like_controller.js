import { Controller } from "@hotwired/stimulus"
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faThumbsUp as regularThumbsUp , faThumbsDown as  regularThumbsUDown } from '@fortawesome/free-regular-svg-icons'
import { faThumbsUp as solidThumbsUP, faThumbsDown as solidThumbsDown } from '@fortawesome/free-solid-svg-icons' 

export default class extends Controller {

  static targets = [ 'thumbsUp', "thumbsDown", "commentLikeCount", "commentDislikeCount" ]

  initialize(){    
    library.add(regularThumbsUp, regularThumbsUDown, solidThumbsUP, solidThumbsDown, )
  }
  connect() {
    dom.watch()

    
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
    const token = document.querySelector("meta[name='csrf-token']").content

    fetch((`/comments/${commentId}/like`), {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": token
      }
    })
    .then((resp) => {
      return resp.json()
    })
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

  dislike() {        

    const commentId = this.element.dataset.commentId
    const token = document.querySelector("meta[name='csrf-token']").content

    fetch((`/comments/${commentId}/dislike`), {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": token
      }
    })
    .then((resp) => {
      return resp.json()
    })
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

