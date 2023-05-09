import { Controller } from "@hotwired/stimulus"
import { fetchWithoutParams } from "../../lib/fetcher"
export default class extends Controller {

  static targets = [ 'published', 'commentsCount', 'likesCount', 'viewsCount' ]

  connect() {    

  }

  filterPublished() { 
    console.log(123);
  }
  filterCommentsCount() {
    // console.log(444);
    // this.activeButton(this.commentsCountTarget)

    
  }
  filterLikesCount() {
    console.log(77);
  }
  filterViewsCount() {
    console.log(78765);
  }
  
  activeButton(activeButton) {
    activeButton.classList.add('bg-slate-100')
  }
}