import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="landing"
export default class extends Controller {
  
  connect() {
  }

  set_record_type () {
    record_type = document.getElementById("record_type")
    if (this.element.id == "btnradio_all") record_type.value = ""
    if (this.element.id == "btnradio_metodologias") record_type.value = "metodologia"
    if (this.element.id == "btnradio_sociales") record_type.value = "social"
    if (this.element.id == "btnradio_ecologicas") record_type.value = "ecologica"
    console.log("set_record_type setted to: " + record_type.value)
  }
}
