import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

// Connects to data-controller="flatpickr"
export default class extends Controller {
  connect() {
    console.log("Flatpickr controller connected", this.element)
    flatpickr(".date_range", {
      mode: "range",
      dateFormat: "Y-m-d"
    })
  }
}
