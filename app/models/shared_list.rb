class SharedList < ApplicationRecord
  include SharedListStateMachine

  belongs_to :user
  has_many :shared_documents
  has_many :documents, through: :shared_documents
  has_many :shared_folders
  has_many :folders, through: :shared_folders
  has_many :contacts

  validates :title, presence: true, uniqueness: { scope: :user }
  validates :code, presence: true, uniqueness: true, length: { is: 16 }

  scope :ordered_by_title, -> { order('lower(title)') }
end
