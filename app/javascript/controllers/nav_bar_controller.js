import { Controller } from "@hotwired/stimulus"
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faCaretDown, faDoorOpen, faBook, faPlus, faHouse } from '@fortawesome/free-solid-svg-icons' 
import { faUser } from '@fortawesome/free-regular-svg-icons' 
// import { faUser, faChevronDown } from '@fortawesome/free-regular-svg-icons' 

export default class extends Controller {

  static targets = [ 'information' ]

  initialize(){    
    library.add(faUser, faCaretDown, faDoorOpen, faBook, faPlus, faHouse)    
  }
  connect() {
    dom.watch()

    this.infoState = false

  }


  login(){
    // console.log(123);

    const evt = new CustomEvent("popup")
    window.dispatchEvent(evt)
  }

  info() {

    if (this.infoState) {
      this.informationTarget.classList.add("hidden")
    } else {
      this.informationTarget.classList.remove("hidden")
    }
    this.infoState = !this.infoState    
  }
}
