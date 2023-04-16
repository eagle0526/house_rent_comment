import { Controller } from "@hotwired/stimulus"
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faX } from '@fortawesome/free-solid-svg-icons' 

export default class extends Controller {
  initialize(){    
    library.add(faX)
  }
  connect() {
    dom.watch()
  }


  login(){
    // console.log(123);

    const evt = new CustomEvent("popup")
    window.dispatchEvent(evt)
  }
}
