import { Controller } from "@hotwired/stimulus"
import { fetchWithoutParams } from "../controllers/lib/fetcher"
import { dispatchAction } from "../controllers/lib/dispatch"
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faHeartCrack } from '@fortawesome/free-solid-svg-icons' 
import { faHeart } from '@fortawesome/free-regular-svg-icons'

export default class extends Controller {

  static targets = [ 'heart', "heartCrack", "houseLikeCount" ]

  initialize(){    
    library.add(faHeart, faHeartCrack)
  }
  connect() {
    dom.watch()    

    // 一進來就先判斷，LikeState中的state到底是空的還是false還是true
    const likeState = this.element.dataset.likeState

    if (likeState === 'true') {      
      this.heartBlue()
    } else if (likeState === 'false') {      
      this.heartCrackBlue()
    }

  }

  heart() {    
    const houseId = this.element.dataset.id
    const userId = this.element.dataset.currentUserId
    
    if (userId === 'Logged out') {
      dispatchAction("popup")
    } else {
      // 這個是新增like的路徑 - /houses/:id/like
      fetchWithoutParams(`/houses/${houseId}/like`, "PATCH")
        .then(({status, houseLikeCount, houseDislikeCount}) => {
          if (status === "liked house") {
            this.heartBlue()
          } else if ( status === 'delete house like_state' ) {
            this.heartWhite()
          } else {
            this.heartBlue()
            this.heartCrackWhite()
          }
          
          // 這邊把後端傳來的實際數量，再用dispatch傳到顯示數量的controller
          const increaseCount = new CustomEvent("increase", {
            detail: {houseLikeCount: houseLikeCount, houseDislikeCount: houseDislikeCount}
          }) 
          window.dispatchEvent(increaseCount)
        })
        .catch((err) => {
          console.log(err);
        })
    }


    
  }

  heartCrack() {

    const houseId = this.element.dataset.id
    const userId = this.element.dataset.currentUserId

    if (userId === 'Logged out') {
      dispatchAction("popup")
    } else {
      // 這個是新增dislike的路徑 - /houses/:id/dislike
      fetchWithoutParams(`/houses/${houseId}/dislike`, "PATCH")
        .then(({status, houseLikeCount, houseDislikeCount}) => {
          if (status === "disliked houses") {
            this.heartCrackBlue()
          } else if (status === "delete house like_state")  {
            this.heartCrackWhite()
          } else {
            this.heartCrackBlue()
            this.heartWhite()
          }    
          // 這邊把後端傳來的實際數量，再用dispatch傳到顯示數量的controller
          const decreaseCount = new CustomEvent("decrease", {
            detail: {houseLikeCount: houseLikeCount, houseDislikeCount: houseDislikeCount}
          }) 
          window.dispatchEvent(decreaseCount)        
        })
        .catch((err) => {
          console.log(err);
        })
    }


  }


  heartBlue() {
    this.heartTarget.classList.add("bg-blue-100")
  }

  heartWhite() {
    this.heartTarget.classList.remove("bg-blue-100")
  }

  heartCrackBlue() {
    this.heartCrackTarget.classList.add("bg-blue-100")
  }

  heartCrackWhite() {
    this.heartCrackTarget.classList.remove("bg-blue-100")
  }



}

