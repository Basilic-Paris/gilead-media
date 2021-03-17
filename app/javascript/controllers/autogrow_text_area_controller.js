import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "area" ]

  connect() {
    // resize body custom-mail input text to fit content
    const input = this.areaTarget

    if (input.offsetHeight != 0) {
      input.style.height = `${input.scrollHeight + (input.offsetHeight - input.clientHeight)}px`
    }

    input.addEventListener('keyup', (event) => {
      input.style.height = null
      input.style.height = `${input.scrollHeight + (input.offsetHeight - input.clientHeight)}px`
    })
  }
}
