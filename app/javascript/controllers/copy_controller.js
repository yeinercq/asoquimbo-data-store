import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="copy"
export default class extends Controller {
  static values = { text: String }

  copy() {
    if (!this.textValue) return

    navigator.clipboard.writeText(this.textValue).then(() => {
      const icon = this.element.querySelector("i")
      if (icon) {
        const original = icon.className
        icon.className = "bi bi-check2"
        setTimeout(() => {
          icon.className = original
        }, 1500)
      }
    })
  }
}
