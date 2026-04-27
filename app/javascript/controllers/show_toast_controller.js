import { Controller } from "@hotwired/stimulus"
import { Toast } from "bootstrap"

// Connects to data-controller="show-toast"
export default class extends Controller {
  connect() {
    this.toast = new Toast(this.element, {
      autohide: true,
      animation: true,
      delay: 5000
    })
    this.toast.show()
  }
}
