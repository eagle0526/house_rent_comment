import { Controller } from "@hotwired/stimulus"


export default class extends Controller {

  static targets = [ 'houseName', 'houseStreet' ]

  connect() {
    
  }


  searchName(){
    this.changeField(this.houseStreetTarget, this.houseNameTarget)
  }

  searchStreet() {    
    this.changeField(this.houseNameTarget, this.houseStreetTarget)
  }

  changeField(fieldOne, fieldTwo) {
    fieldOne.classList.add("hidden")    
    fieldTwo.classList.remove("hidden")    
  }

}
