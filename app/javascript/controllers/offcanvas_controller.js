import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

// Connects to data-controller="offcanvas"
export default class extends Controller {
  connect() {
    this.offcanvas = new bootstrap.Offcanvas(this.element)
  }

  open() {
    if (!this.offcanvas.isOpened) {
      this.offcanvas.show()
    }
  }

  close(event) {
    if (event.detail.success) {
      this.offcanvas.hide()
    }
  }
}
