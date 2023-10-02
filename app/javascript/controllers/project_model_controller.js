import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="project-model"
export default class extends Controller {
  connect() {
    console.log("i am Connected!!")
  }

  initialize()
  {
    this.element.setAttribute("data-action", "click->project-model#showModel")
  }

  showModel(event){
    event.preventDefault()
    this.url = this.element.getAttribute("href")
    fetch(this.url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
  }


}
