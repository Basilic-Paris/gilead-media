class SharedDocument < ApplicationRecord
  include SharedDocumentStateMachine

  belongs_to :document
  has_many :contacts, as: :contactable

  validates :code, presence: true, uniqueness: true, length: { is: 16 }
  validates :contacts, presence: true
end
