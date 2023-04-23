import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'page' ]

  connect() {}

  showPop() {
    this.pageTarget.classList.remove("hidden")
  }

  close() {
    this.pageTarget.classList.add("hidden") 
  }
}
