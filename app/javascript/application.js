// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

document.addEventListener("turbo:load", () => {
  // Toasts
  document.querySelectorAll('.toast').forEach(toastEl => {
    bootstrap.Toast.getOrCreateInstance(toastEl, {
      autohide: true,
      animation: true,
      delay: 5000
    }).show()
  })

  // Dropdowns
  document.querySelectorAll('[data-bs-toggle="dropdown"]').forEach(el => {
    bootstrap.Dropdown.getOrCreateInstance(el)
  })

  // Popovers
  document.querySelectorAll('[data-bs-toggle="popover"]').forEach(el => {
    bootstrap.Popover.getOrCreateInstance(el)
  })

  // ScrollSpy (smooth scroll + nav highlighting on the landing page)
  document.querySelectorAll('[data-bs-spy="scroll"]').forEach(el => {
    bootstrap.ScrollSpy.getOrCreateInstance(el)
  })
})
