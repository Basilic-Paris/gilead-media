class Folder < ApplicationRecord
  has_many :document_folders
  has_many :documents, through: :document_folders
  has_many :shared_folders
  has_many :shared_lists, through: :shared_folders

  validates :title, presence: true, uniqueness: true

  scope :ordered_by_title, -> { order('lower(title)') }
  scope :with_documents, -> { joins(document_folders: :document).distinct }
  # scope :with_validated_documents, -> { joins(document_folders: :document).where.not({ documents: { validation_at: nil } }).distinct }
  scope :with_validated_documents, -> { with_documents.where.not({ documents: { validation_at: nil } }) }

  def shared_lists_attributes=(shared_list_attributes)
    shared_list_attributes.values.each do |shared_list_attribute|
      if shared_list_attribute[:title].present? && shared_list_attribute[:user_id].present?
        shared_list = SharedList.find_or_create_by(shared_list_attribute)
        self.shared_lists << shared_list unless self.shared_lists.include?(shared_list)
      end
    end
  end
end
