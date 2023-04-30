import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'fileUploader', "filename" ]


  connect() {}

  upload(e) {    
    const fileList = e.target.files;    
    filename.innerHTML = '';

    for (let i = 0; i < fileList.length; i++) {
      const file = fileList[i];
      const span = document.createElement('span');
      span.innerText = file.name;
      
      if (i < fileList.length - 1) {
        span.innerText += ' / ';
      }           
      filename.appendChild(span);
    }

    // filename.classList.remove('hidden');

  }
}
