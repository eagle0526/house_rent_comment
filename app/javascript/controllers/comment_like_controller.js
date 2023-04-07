import { Controller } from "@hotwired/stimulus"
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faThumbsUp as regularThumbsUp , faThumbsDown as  regularThumbsUDown } from '@fortawesome/free-regular-svg-icons'
import { faThumbsUp as solidThumbsUP, faThumbsDown as solidThumbsDown } from '@fortawesome/free-solid-svg-icons' 

export default class extends Controller {

  static targets = [ 'thumbsUp', "thumbsDown" ]

  initialize(){    
    library.add(regularThumbsUp, regularThumbsUDown, solidThumbsUP, solidThumbsDown, )
  }
  connect() {
    dom.watch()

    
    const commentLikeState = this.element.dataset.commentLikeState
    if (commentLikeState === 'true') {
      this.thumbsUpTarget.classList.add("fa-solid")
      this.thumbsUpTarget.classList.remove("fa-regular")

      this.thumbsDownTarget.classList.add("fa-regular")
      this.thumbsDownTarget.classList.remove("fa-solid")

    } else if (commentLikeState === 'false') {
      this.thumbsUpTarget.classList.add("fa-regular")
      this.thumbsUpTarget.classList.remove("fa-solid")
      
      this.thumbsDownTarget.classList.add("fa-solid")
      this.thumbsDownTarget.classList.remove("fa-regular")
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
    .then(({status}) => {
      
      if (status === "liked comment") {
        this.thumbsUpTarget.classList.add("fa-solid")
        this.thumbsUpTarget.classList.remove("fa-regular")
      } else if (status === "delete comment like_state") {        
        this.thumbsUpTarget.classList.add("fa-regular")
        this.thumbsUpTarget.classList.remove("fa-solid")
      } else {
        // 倒讚
        this.thumbsDownTarget.classList.remove("fa-solid")
        this.thumbsDownTarget.classList.add("fa-regular")
        // 正讚
        this.thumbsUpTarget.classList.add("fa-solid")
        this.thumbsUpTarget.classList.remove("fa-regular")
      }

    })
    .catch((err) => {
      console.log(err);
    })
    


  }

  dislike() {    
    // console.log(this.thumbsDownTarget);

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
    .then(({status}) => {
      
      if (status === "disliked comment") {
        this.thumbsDownTarget.classList.add("fa-solid")
        this.thumbsDownTarget.classList.remove("fa-regular")
      } else if (status === "delete comment like_state") {        
        this.thumbsDownTarget.classList.add("fa-regular")
        this.thumbsDownTarget.classList.remove("fa-solid")
      } else {
        // 倒讚
        this.thumbsUpTarget.classList.remove("fa-solid")
        this.thumbsUpTarget.classList.add("fa-regular")
        // 正讚
        this.thumbsDownTarget.classList.add("fa-solid")
        this.thumbsDownTarget.classList.remove("fa-regular")
      }

    })
    .catch((err) => {
      console.log(err);
    })


  }



}

