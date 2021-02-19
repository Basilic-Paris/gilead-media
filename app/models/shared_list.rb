class SharedList < ApplicationRecord
  include SharedListStateMachine
  include ContactHelper

  belongs_to :user
  has_many :document_shared_lists
  has_many :documents, through: :document_shared_lists
  has_many :folder_shared_lists
  has_many :folders, through: :folder_shared_lists
  has_many :contacts, as: :contactable

  validates :title, presence: true, uniqueness: { scope: :user }
  validates :code, presence: true, uniqueness: true, length: { is: 16 }
  validates :contacts, presence: true, on: :update

  scope :ordered_by_title, -> { order('lower(title)') }
end
