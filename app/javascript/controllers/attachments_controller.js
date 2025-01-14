import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = []

  connect() {
    const clone = document.getElementById('document_attachments').parentNode.cloneNode(true)
    this.setNewAttachmentInputOnAttachmentChange(clone)
  }

  setNewAttachmentInputOnAttachmentChange = (clone) => {
    document.getElementById('document_attachments').addEventListener("change", (event) => {
      // event.currentTarget.style.setProperty('--display', 'block')
      event.currentTarget.parentNode.classList.remove('d-none')
      event.currentTarget.parentNode.classList.add('d-flex')
      event.currentTarget.parentNode.before(clone)
      this.connect()
    })
  }

  removeAttachmentInput(event) {
    event.currentTarget.parentNode.remove()
  }

  attach() {
    document.getElementById("document_attachments").click()
  }
}
