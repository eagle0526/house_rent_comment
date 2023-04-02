import { Controller } from "@hotwired/stimulus"
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faMagnifyingGlass } from '@fortawesome/free-solid-svg-icons'

export default class extends Controller {
  initialize(){
    library.add(faMagnifyingGlass)
  }
  connect() {
    dom.watch()
  }
}
