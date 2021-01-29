import { Controller } from "stimulus"
import flatpickr from 'plugins/flatpickr';

export default class extends Controller {
  static targets = [ "dropdownIcon", "moreOptions", "datesSelection" ]

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

    this.moreOptionsTarget.classList.toggle('visible');
    this.moreOptionsTarget.classList.toggle('invisible');
  }
}
