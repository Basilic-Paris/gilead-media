import { Controller } from "stimulus"
import flatpickr from 'plugins/flatpickr/flatpickr';

export default class extends Controller {
  static targets = [ "dropdownIcon", "moreOptions", "datesSelection", "title", "format", "language", "firstSubmitButton" ]

  connect() {
    flatpickr(this.datesSelectionTarget, {
      // locale: "fr", # replace by flatpickr.localize(French)
      mode: "range",
      altInput: true,
      altFormat: "D j F Y",
      dateFormat: "Y-m-d"
    });
  }

  toggle() {
    this.dropdownIconTarget.classList.toggle('fa-sort-down');
    this.dropdownIconTarget.classList.toggle('fa-sort-up');
    this.dropdownIconTarget.classList.toggle('align-self-end');
    this.firstSubmitButtonTarget.classList.toggle('d-none');

    this.moreOptionsTarget.classList.toggle('visible');
    this.moreOptionsTarget.classList.toggle('invisible');
  }

  clearSearchValues() {
    this.titleTarget.value = ""
    this.datesSelectionTarget.value = ""
    this.formatTarget.value = ""
    this.languageTarget.value = ""
  }

  disconnect() {
    this.clearSearchValues()
    if (this.dropdownIconTarget.classList.contains('fa-sort-up')) {
      this.toggle()
    }
  }
}
