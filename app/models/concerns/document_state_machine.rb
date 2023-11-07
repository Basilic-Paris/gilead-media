module DocumentStateMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm do
      state :active, initial: true, display: 'Actif'
      state :inactive, display: 'Inactif'
      state :archived, display: 'Archivé'
    end
  end
end
