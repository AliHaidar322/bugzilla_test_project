import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bs-model"
export default class extends Controller {
  connect() {
    this.modal = new bootstrap.Modal(this.element)
    this.modal.show()
  }

  disconnect(){
    this.modal.hide()
  }
  submitEnd(event){
    if (this.element.checkValidity()) {
      this.modal.hide()
    } else {
      // Display the validation errors
    }
  }
}
