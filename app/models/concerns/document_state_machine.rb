module DocumentStateMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm do
      state :active, display: 'Actif'
      state :inactive, initial: true, display: 'Inactif'
      state :archived, display: 'Archivé'

      event :active do
        before :set_validation_at
        transitions from: [:inactive], to: :active
      end

      event :unactive do
        transitions from: [:active], to: :inactive
      end

      event :archive do
        transitions from: [:active], to: :archived
      end
    end

    def set_validation_at
      self.validation_at = DateTime.now
    end
  end
end
