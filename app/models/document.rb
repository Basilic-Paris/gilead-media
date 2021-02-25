class Document < ApplicationRecord
  include DatetimeHelper
  include PgSearch::Model

  acts_as_taggable_on :tags

  has_one_attached :attachment
  has_many :document_folders, dependent: :destroy
  has_many :shared_documents, dependent: :destroy
  has_many :folders, through: :document_folders
  has_many :document_shared_lists, dependent: :destroy
  has_many :shared_lists, through: :document_shared_lists

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

  LANGUAGES = {
    "FR": "Français",
    "EN": "Anglais"
  }

  FORMATS = {
    "image": "Image",
    "video": "Vidéo",
    "pdf": "Pdf",
    "ppt": "Power-Point",
    "xls": "Excel",
    "word": "Word",
    "autres": "Autres"
  }

  validates :title, presence: true, uniqueness: true
  validates :language, presence: true, inclusion: { in: LANGUAGES.stringify_keys.keys }
  validates :attachment, presence: true

  scope :validated, -> { where.not(validation_at: nil) }
  # scope :created_in_day, ->(datetime) { where('created_at > ? AND created_at < ?', datetime.beginning_of_day, datetime.end_of_day) }
  scope :created_in_days_range, ->(start_datetime, end_datetime) { where('created_at > ? AND created_at < ?', start_datetime.beginning_of_day, end_datetime.end_of_day) }

  before_save :set_format

  pg_search_scope :advanced_search, lambda { |column_name, query|
    {
      against: column_name,
      ignoring: :accents,
      using: {
        tsearch: { any_word: true }
      },
      query: query
    }
  }

  def validated?
    validation_at.present?
  end

  # TO KEEP: initial version to add folders or documents to shared list directly
  # def shared_lists_attributes=(shared_list_attributes)
  #   shared_list_attributes.values.each do |shared_list_attribute|
  #     if shared_list_attribute[:title].present? && shared_list_attribute[:user_id].present?
  #       shared_list = SharedList.find_or_create_by(shared_list_attribute)
  #       self.shared_lists << shared_list unless self.shared_lists.include?(shared_list)
  #     end
  #   end
  # end

  def folders_attributes=(folder_attributes)
    folder_attributes.values.each do |folder_attribute|
      if folder_attribute[:title].present?
        folder = Folder.find_or_create_by(folder_attribute)
        self.folders << folder
      end
    end
  end

  def attachment_extension
    attachment.blob.filename.to_s.split(".").last
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
      case content_type
      when "image/gif"
        self.format = "image"
      when "image/png"
        self.format = "image"
      when "image/jpeg"
        self.format = "image"
      else
        self.format = "other"
      end
    when "video"
      case content_type
      when "video/mp4"
        self.format = "video"
      when "video/quicktime"
        self.format = "video"
      else
        self.format = "other"
      end
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
