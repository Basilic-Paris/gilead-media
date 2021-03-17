class SharedDocument < ApplicationRecord
  include SharedDocumentStateMachine
  include ContactHelper

  belongs_to :document
  belongs_to :user
  has_many :contacts, as: :contactable, dependent: :destroy
  has_one :custom_mail, as: :mailable, dependent: :destroy

  validates :code, presence: true, uniqueness: true, length: { is: 16 }
  validates :download, inclusion: { in: [true, false] }
  validates :contacts, presence: true
  validates :custom_mail, presence: true

  accepts_nested_attributes_for :custom_mail
end
