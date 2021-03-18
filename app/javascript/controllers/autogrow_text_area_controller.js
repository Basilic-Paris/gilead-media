import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "area" ]

  connect() {
    const areass = this.areaTargets

    areas.forEach((input) => {
      this.autogrowTextArea(area)
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
