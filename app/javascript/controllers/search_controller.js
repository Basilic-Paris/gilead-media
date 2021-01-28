import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "dropdownIcon", "moreOptions" ]

  toggle() {
    this.dropdownIconTarget.classList.toggle('fa-sort-down');
    this.dropdownIconTarget.classList.toggle('fa-sort-up');
    this.moreOptionsTarget.classList.toggle('d-none');
    this.moreOptionsTarget.classList.toggle('d-flex');
  }
}
