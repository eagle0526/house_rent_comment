import { Controller } from "@hotwired/stimulus"
import { dispatchAction } from "../controllers/lib/dispatch"

export default class extends Controller {
  static targets = [ '' ]

  connect() {
    
  }

  comment() {
    const userId = this.element.dataset.currentUserId

    if (userId === 'Logged out') {
      dispatchAction("popup")
    }
  }


}
