import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'page' ]

  initialize(){    
    
  }
  connect() {
  
  }

  showPop() {
    // console.log(this.pageTarget);

    this.pageTarget.classList.remove("hidden")

  }

  close() {
    this.pageTarget.classList.add("hidden")
  }
}
