module SharedDocumentStateMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm do
      state :initial, initial: true
      state :contacts_added

      event :add_contacts do
        transitions from: [:initial],
          to: :contacts_added
      end
    end
  end
end
