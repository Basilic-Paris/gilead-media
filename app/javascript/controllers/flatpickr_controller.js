import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    'dateSelection'
  ]

  connect() {
    if (this.hasDateSelectionTarget) {
      flatpickr(this.dateSelectionTarget, {
        // locale: "fr", # replace by flatpickr.localize(French)
        // mode: "range",
        minDate: 'today',
        altInput: true,
        altFormat: "D j F Y",
        dateFormat: "Y-m-d"
      });
    }
  }
}
