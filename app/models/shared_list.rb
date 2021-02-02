class SharedList < ApplicationRecord
  belongs_to :user
  has_many :shared_documents
  has_many :documents, through: :shared_documents
  has_many :shared_folders
  has_many :folders, through: :shared_folders

  validates :title, presence: true, uniqueness: { scope: :user }

  scope :ordered_by_title, -> { order('lower(title)') }
end
