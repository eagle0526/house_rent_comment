import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'likeCount', 'disLikeCount' ]

  initialize(){    
    
  }
  connect() {
    
  }

  increase({detail}) {    
    this.setTextContent(detail.houseLikeCount, detail.houseDislikeCount)    
  }

  decrease({detail}) {
    this.setTextContent(detail.houseLikeCount, detail.houseDislikeCount)    

  }

  setTextContent(houseLikeCount, houseDislikeCount) {
    this.likeCountTarget.textContent = houseLikeCount
    this.disLikeCountTarget.textContent = houseDislikeCount
  }


}

