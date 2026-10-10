import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  connect() {
  }

  clean_pagy() {
    const pagyFrame = document.getElementById("pagy");
    if (pagyFrame) {
      pagyFrame.src = "";
    }
  }
}
