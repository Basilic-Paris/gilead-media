import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "moreOptions", "dropdownIcon", "elementToToggle" ]

  connect() {
  }

  toggle() {
    this.moreOptionsTarget.classList.toggle('visible');
    this.moreOptionsTarget.classList.toggle('invisible');
  }

  toggleClasses() {
    this.elementToToggleTarget.getAttribute('data-class-to-toggle').split(', ').forEach((className) => {
      this.elementToToggleTarget.classList.toggle(className)
    })
  }

  toggleWithIcon() {
    this.dropdownIconTarget.classList.toggle('fa-sort-down');
    this.dropdownIconTarget.classList.toggle('fa-sort-up');
    this.dropdownIconTarget.classList.toggle('align-self-end');

    this.moreOptionsTarget.classList.toggle('visible');
    this.moreOptionsTarget.classList.toggle('invisible');
  }
}
