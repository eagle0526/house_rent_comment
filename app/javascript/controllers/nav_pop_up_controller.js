import { Controller } from "@hotwired/stimulus"
import { library, dom } from '@fortawesome/fontawesome-svg-core'
// import { faXmark, faXmarkLarge, faThumbsUp } from '@fortawesome/free-regular-svg-icons'
import { faX } from '@fortawesome/free-solid-svg-icons' 

export default class extends Controller {

  static targets = [ 'page' ]

  initialize(){    
    library.add(faX)
  }
  connect() {
    dom.watch()
  }

  showPop() {
    // console.log(this.pageTarget);

    this.pageTarget.classList.remove("hidden")

  }

  close() {
    this.pageTarget.classList.add("hidden")
  }
}
