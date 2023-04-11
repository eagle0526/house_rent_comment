import { Controller } from "@hotwired/stimulus"
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faHeartCrack } from '@fortawesome/free-solid-svg-icons' 
import { faHeart } from '@fortawesome/free-regular-svg-icons'

export default class extends Controller {

  static targets = [ 'likeCount', 'disLikeCount' ]

  initialize(){    
    library.add(faHeart, faHeartCrack)
  }
  connect() {
    dom.watch()        
  }

  increase({detail}) {    

    this.likeCountTarget.textContent = detail.houseLikeCount    
    this.disLikeCountTarget.textContent = detail.houseDislikeCount
  }

  decrease({detail}) {
    
    this.likeCountTarget.textContent = detail.houseLikeCount
    this.disLikeCountTarget.textContent = detail.houseDislikeCount

  }


}

