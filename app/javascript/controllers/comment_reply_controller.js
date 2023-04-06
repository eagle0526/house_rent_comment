import { Controller } from "@hotwired/stimulus"
import { library, dom } from '@fortawesome/fontawesome-svg-core'
// import { faX } from '@fortawesome/free-solid-svg-icons'

export default class extends Controller {
  static targets = [ 'form' ]

  connect() {
    this.replyState = false
  }

  reply() {
    if (this.replyState){
      this.formTarget.classList.add("hidden")
    } else {
      this.formTarget.classList.remove("hidden")
    }
    this.replyState = !this.replyState
  }
}
