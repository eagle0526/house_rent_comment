import { Controller } from "@hotwired/stimulus"
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { faHeartCrack } from '@fortawesome/free-solid-svg-icons' 
import { faHeart } from '@fortawesome/free-regular-svg-icons'

export default class extends Controller {

  static targets = [ 'heart', "heartCrack" ]

  initialize(){    
    library.add(faHeart, faHeartCrack)
  }
  connect() {
    dom.watch()
    
    

    // 一進來就先判斷，LikeState中的state到底是空的還是false還是true
    const heartState = this.element.dataset.liked
    if (heartState == 'true') {
      this.heartTarget.classList.add("bg-blue-100")
    } else {
      this.heartTarget.classList.remove("bg-blue-100") 
    }

    const heartCrackState = this.element.dataset.disliked

    if (heartCrackState == 'true') {
      this.heartCrackTarget.classList.add("bg-blue-100")      
    } else {
      this.heartCrackTarget.classList.remove("bg-blue-100")       
    }




  }

  heart() {

    console.log(this.element.dataset);
    const houseID = this.element.dataset.id
    const token = document.querySelector("meta[name='csrf-token']").content    

    // 這個是新增like的路徑 - /houses/:id/like
    fetch(`/houses/${houseID}/like`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": token
      }
    })
    .then((resp) => {
      return resp.json()
    })
    .then(({status}) => {
      // console.log(status);

      if (status === "liked") {
        this.heartTarget.classList.add("bg-blue-100")
      } else {
        this.heartTarget.classList.remove("bg-blue-100") 
      }

    })
    .catch((err) => {
      console.log(err);
    })
  }

  heartCrack() {

    const houseID = this.element.dataset.id
    const token = document.querySelector("meta[name='csrf-token']").content    

    fetch(`/houses/${houseID}/dislike`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": token
      }
    })
    .then((resp) => {
      return resp.json()
    })
    .then(({status}) => {
      // console.log(status);
      if (status === "disliked") {
        this.heartCrackTarget.classList.add("bg-blue-100")
      } else if (status === "delete like_state")  {
        this.heartCrackTarget.classList.remove("bg-blue-100") 
      } else {
        this.heartCrackTarget.classList.add("bg-blue-100")
        this.heartTarget.classList.remove("bg-blue-100") 
      }
    })
    .catch((err) => {
      console.log(err);
    })

    // if (this.heartCrackState) {      
    //   this.heartCrackTarget.classList.remove("bg-blue-100")
    // } else {            
    //   this.heartCrackTarget.classList.add("bg-blue-100")
    // }
    // this.heartCrackState = !this.heartCrackState    
    
  }


  setColor() {

  }

}

