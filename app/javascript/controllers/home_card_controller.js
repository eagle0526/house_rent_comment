import { Controller } from "@hotwired/stimulus"
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { fetchWithoutParams } from "../controllers/lib/fetcher"
import { faThumbsUp, faThumbsDown, faHeart, faCommentDots, faClock, faEye } from '@fortawesome/free-regular-svg-icons'


export default class extends Controller {

  static targets = [ 'houseLikeCount', "houseDisLikeCount" ]

  initialize(){    
    library.add(faThumbsUp, faThumbsDown, faHeart, faCommentDots, faClock, faEye)
  }
  connect() {
    dom.watch()    
  }

  increase() {
    const houseID = this.element.dataset.houseId
    
    // 這個是新增like的路徑 - /houses/:id/like
    fetchWithoutParams(`/houses/${houseID}/like`, "PATCH")
      .then(({status, houseLikeCount, houseDislikeCount}) => {

        this.setTextContent(houseLikeCount, houseDislikeCount)

      })
      .catch((err) => {
        console.log(err);
      })
  }

  decrease() {
    const houseID = this.element.dataset.houseId
    
    // 這個是新增like的路徑 - /houses/:id/like
    fetchWithoutParams(`/houses/${houseID}/dislike`, "PATCH")
      .then(({status, houseLikeCount, houseDislikeCount}) => {

        this.setTextContent(houseLikeCount, houseDislikeCount)

      })
      .catch((err) => {
        console.log(err);
      })
  }

  setTextContent(houseLikeCount, houseDislikeCount) {
    this.houseLikeCountTarget.textContent = houseLikeCount
    this.houseDisLikeCountTarget.textContent = houseDislikeCount
  }

}
