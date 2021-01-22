class Folder < ApplicationRecord
  has_many :document_folders
  has_many :documents, through: :document_folders

  validates :title, presence: true, uniqueness: true

  default_scope { order('lower(title)') }
end
