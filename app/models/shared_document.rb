class SharedDocument < ApplicationRecord
  include SharedDocumentStateMachine

  belongs_to :shared_list
  belongs_to :document

  validates :shared_list, uniqueness: { scope: :document }
end
