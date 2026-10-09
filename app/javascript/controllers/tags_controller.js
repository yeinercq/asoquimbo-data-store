import { Controller } from "@hotwired/stimulus"
import Tagify from "@yaireo/tagify"

// Connects to data-controller="tags"
export default class extends Controller {
  connect() {
    const initialValue = this.element.value.trim()

    // Tagify espera JSON por defecto; limpiamos antes de inicializar
    // y luego cargamos las etiquetas como valores separados por coma.
    this.element.value = ""

    this.tagify = new Tagify(this.element, {
      delimiters: ",",
      originalInputValueFormat: valuesArr => valuesArr.map(item => item.value).join(",")
    })

    if (initialValue) {
      this.tagify.addTags(initialValue.split(",").map(tag => tag.trim()).filter(Boolean))
    }
  }

  disconnect() {
    this.tagify.destroy()
  }
}
