// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "jquery"
import "bootstrap"
import "plugins/jquery"
import "plugins/flatpickr"

// document.addEventListener('turbo:load', () => {
//   // Call your functions here, e.g:
//   // initSelect2();
//   initComponents();
// });

Turbo.StreamActions.open_modal = function () {
  // console.log(this)
  // console.log(this.action)
  // console.log(this.target)
  // $(`.modal#${this.target}`).modal("show")
  // $(`${this.target}`).modal("show")
  $(this.target).modal("show")
};

Turbo.StreamActions.close_modal = function () {
  // console.log(this)
  // console.log(this.action)
  // console.log(this.target)
  // $(`.modal#${this.target}`).modal("hide")
  // $(`${this.target}`).modal("hide")
  $(this.target).modal("hide")
};

Turbo.StreamActions.remove_validation_errors = function() {
  $('.invalid-feedback').html('');
  $('.is-valid').removeClass('is-valid');
  $('.is-invalid').removeClass('is-invalid');
}

Turbo.StreamActions.set_validation_errors = function () {
  const attributes = JSON.parse(this.getAttribute("attributes"))
  $(attributes["elementId"]).addClass('is-invalid ')
  $(attributes["invalidFeedbackElement"]).html(
    attributes["message"]
  );
}

Turbo.StreamActions.replace_element_attribute = function () {
  const attributes = JSON.parse(this.getAttribute("attributes"))
  $(attributes["element"]).attr(attributes["attribute"], attributes["newAttributeValue"])
}

Turbo.StreamActions.remove_parent = function () {
  document.querySelector(this.target).parentNode.remove()
}

Turbo.StreamActions.remove_element = function () {
  document.querySelector(this.target).remove()
}

Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.target);
};

Turbo.setConfirmMethod((message, element) => {
  let dialog = document.getElementById("turbo-confirm")
  dialog.querySelector("p").outerHTML = message
  dialog.showModal()
  return new Promise((resolve, reject) => {
    dialog.addEventListener('click', (event) => {
      event.currentTarget === event.target && dialog.close();
    })
    dialog.addEventListener("close", () => {
      resolve(dialog.returnValue === "confirm")
    }, { once: true })
  })
})
