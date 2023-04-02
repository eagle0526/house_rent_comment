import { Controller } from "@hotwired/stimulus"
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faThumbsUp, faThumbsDown, faHeart, faMessageDots } from '@fortawesome/free-regular-svg-icons'

export default class extends Controller {
  initialize(){
    library.add(faThumbsUp, faThumbsDown, faHeart, faMessageDots)
  }
  connect() {
    dom.watch()
  }
}
