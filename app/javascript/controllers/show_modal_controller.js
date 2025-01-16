import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    'modalId'
  ]

  connect() {
    $('#' + this.modalIdTarget.id).modal('show');
  }
}
