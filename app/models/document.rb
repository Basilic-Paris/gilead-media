class Document < ApplicationRecord
  include DatetimeHelper

  has_one_attached :attachment
  has_many :document_folders
  has_many :folders, through: :document_folders

  # accepts_nested_attributes_for :folders, reject_if: -> (folder) { folder[:title].blank? }
  ## do the same thing
  # accepts_nested_attributes_for :folders, reject_if: lambda { |folder| folder[:title].blank? }
  ## do the same thing
  # accepts_nested_attributes_for :folders, reject_if: :title_is_nil
  # def title_is_nil(folder) # à mettre dans private
  #   folder[:title].blank?
  # end
  # => not working in case we enter an already existing folder
  # => replaced by def folders_attributes=(folder_attributes)

  LANGUAGES = %w[FR EN]

  validates :title, presence: true
  validates :language, presence: true, inclusion: { in: LANGUAGES }
  # validates :attachment, presence: true

  scope :validated, -> { where.not(validation_at: nil) }

  before_save :set_format

  def validated?
    validation_at.present?
  end

  def folders_attributes=(folder_attributes)
    folder_attributes.values.each do |folder_attribute|
      if folder_attribute[:title].present?
        folder = Folder.find_or_create_by(folder_attribute)
        self.folders << folder
      end
    end
  end

  private

  def content_type
    self.attachment.blob.content_type
  end

  def main_content_type
    content_type.split("/").first
  end

  def set_format
    case main_content_type
    when "image"
      self.format = "image"
    when "video"
      self.format = "video"
    when "application"
      case content_type
      when "application/pdf"
        self.format = "pdf"
      when "application/vnd.ms-powerpoint", "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        self.format = "ppt"
      when "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        self.format = "xls"
      when "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        self.format = "word"
      else
        self.format = "other"
      end
    else
      self.format = "other"
    end
  end
end
