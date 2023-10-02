import { Application } from "@hotwired/stimulus"

//= require turbolinks
const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
