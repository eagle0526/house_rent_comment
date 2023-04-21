import { Controller } from "@hotwired/stimulus"

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
