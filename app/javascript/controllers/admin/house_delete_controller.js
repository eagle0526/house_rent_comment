import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'popup' ]

  connect() {    
    this.popupState = false
  }

  delete() {
    // console.log(popupTarget);
    if (this.popupState) {
        this.popupTarget.classList.add("hidden")
      } else {
        this.popupTarget.classList.remove("hidden")
      }
      this.popupState = !this.popupState        
  }
}