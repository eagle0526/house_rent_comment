import { Controller } from "@hotwired/stimulus"
import { dispatchAction } from "./lib/dispatch"

export default class extends Controller {

  static targets = [ ]

  connect() {}

  lookPics() {

    dispatchAction("popup_carousel")
    
  }


}
