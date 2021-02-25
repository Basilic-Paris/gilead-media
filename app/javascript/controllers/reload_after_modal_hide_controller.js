import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    $('#validationModal').on('hidden.bs.modal', event => {
      document.location.reload();
    })
  }
}
