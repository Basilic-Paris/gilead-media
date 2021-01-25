class Folder < ApplicationRecord
  has_many :document_folders
  has_many :documents, through: :document_folders

  validates :title, presence: true, uniqueness: true

  scope :ordered_by_title, -> { order('lower(title)') }
  scope :with_documents, -> { joins(document_folders: :document).distinct }
  # scope :with_validated_documents, -> { joins(document_folders: :document).where.not({ documents: { validation_at: nil } }).distinct }
  scope :with_validated_documents, -> { with_documents.where.not({ documents: { validation_at: nil } }) }
end
