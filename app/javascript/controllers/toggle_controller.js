import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "moreOptions" ]

  connect() {
    console.log("Hello")
  }

  toggle() {
    this.moreOptionsTarget.classList.toggle('visible');
    this.moreOptionsTarget.classList.toggle('invisible');
  }
}
