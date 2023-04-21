import { Controller } from "@hotwired/stimulus"
import { fetchWithoutParams } from "../controllers/lib/fetcher"
import { dispatchAction } from "../controllers/lib/dispatch"


export default class extends Controller {

  static targets = [ 'houseLikeCount', "houseDisLikeCount" ]

  initialize(){    
    
  }
  connect() {    
  }

  increase() {          
    const houseId = this.element.dataset.houseId
    const userId = this.element.dataset.currentUserId

    if (userId === 'Logged out') {
      // 點擊的時候，判斷是否有登入，如果沒登入的話，觸發 nav_pop_up_controller.js 這個controller，把該section的hidden刪掉
      // const evt = new CustomEvent("popup")
      // window.dispatchEvent(evt)            
      
      // 我把他弄成一個方法，這樣之後就不用一直寫上面那兩行，只要把action傳進來就好
      dispatchAction("popup")
    } else {
    // 這個是新增like的路徑 - /houses/:id/like
    fetchWithoutParams(`/houses/${houseId}/like`, "PATCH")
      .then(({status, houseLikeCount, houseDislikeCount}) => {
        this.setTextContent(houseLikeCount, houseDislikeCount)
      })
      .catch((err) => {
        console.log(err);
      })            
    }  
  }

  decrease() {
    const houseId = this.element.dataset.houseId
    const userId = this.element.dataset.currentUserId

    if (userId === 'Logged out') {
      // 點擊的時候，判斷是否有登入，如果沒登入的話，觸發 nav_pop_up_controller.js 這個controller，把該section的hidden刪掉
      // const evt = new CustomEvent("popup")
      // window.dispatchEvent(evt)     

      dispatchAction("popup")
    } else {
      // 這個是新增like的路徑 - /houses/:id/like
      fetchWithoutParams(`/houses/${houseId}/dislike`, "PATCH")
        .then(({status, houseLikeCount, houseDislikeCount}) => {
          this.setTextContent(houseLikeCount, houseDislikeCount)
        })
        .catch((err) => {
          console.log(err);
        })
      }
  }

  setTextContent(houseLikeCount, houseDislikeCount) {
    this.houseLikeCountTarget.textContent = houseLikeCount
    this.houseDisLikeCountTarget.textContent = houseDislikeCount
  }

}
