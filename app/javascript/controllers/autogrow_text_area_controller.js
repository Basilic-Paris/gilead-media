import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "area" ]

  connect() {
    const textInputs = this.areaTargets

    textInputs.forEach((textInput) => {
      this.autogrowTextArea(textInput)
    })
  }

  autogrowTextArea = (area) => {
    if (area.offsetHeight != 0) {
      area.style.overflow = "hidden"
      area.style.height = `${area.scrollHeight + (area.offsetHeight - area.clientHeight)}px`
    }

    area.addEventListener('keyup', (event) => {
      area.style.overflow = "hidden"
      area.style.height = null
      area.style.height = `${area.scrollHeight + (area.offsetHeight - area.clientHeight)}px`
    })
  }
}
