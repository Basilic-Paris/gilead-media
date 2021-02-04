const initDataConfirmModal = () => {
  require("data-confirm-modal");

  dataConfirmModal.setDefaults({
    title: '',
    commit: 'Valider',
    cancel: 'Annuler'
  });
};

export { initDataConfirmModal };
