class Document < ApplicationRecord
  include DocumentStateMachine
  include DatetimeHelper
  include PgSearch::Model
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  acts_as_taggable_on :tags

  # has_one_attached :attachment
  has_many_attached :attachments
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
    "EN": "Anglais",
    "FR, EN": "Français, Anglais"
  }

  FORMATS = [
    "Image", "Vidéo", "Pdf", "Power-Point", "Excel", "Word", "Autres"
  ]

  THEMES = [
    "VIH",
    "Hépatite virale",
    "CAR-T",
    "Oncologie",
    "Policies",
    "RSE",
    "Empreinte",
  ]

  validates :title, presence: true, uniqueness: true
  validates :language, presence: true, inclusion: { in: LANGUAGES.stringify_keys.keys }
  validates :theme, presence: true, inclusion: { in: THEMES }
  validates :attachments, presence: true
  validate :no_duplicate_filename

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

  # def attachment_extension
  #   attachment.blob.filename.to_s.split(".").last
  # end

  def preview_icon(attrs = {})
    attachment = attrs[:attachment]
    return false if attachment.blank? && attachment.new_record? && attachment.blob.blank?
    case attachment.blob.content_type.split("/").first
    when "image"
      image_tag(attachment, class: attrs[:class], style: "max-height: 100%; max-width: 100%; width: #{attrs[:width] if attrs[:width].present?}; height: #{attrs[:height] if attrs[:height].present?}; object-fit: #{attrs['object-fit'] if attrs['object-fit'].present?};")
    when "video"
      video_tag(attachment.service_url + "#t=0.5", controls: attrs[:with_video_controls], class: attrs[:class], style: "max-height: 100%; max-width: 100%; width: #{attrs[:width] if attrs[:width].present?}; height: #{attrs[:height] if attrs[:height].present?}; object-fit: #{attrs['object-fit'] if attrs['object-fit'].present?};")
    else
      if attachment.previewable?
        image_tag(attachment.preview(resize_to_limit: [400, 400]), class: attrs[:class], style: "max-height: 100%; max-width: 100%; width: #{attrs[:width] if attrs[:width].present?}; height: #{attrs[:height] if attrs[:height].present?}; object-fit: #{attrs['object-fit'] if attrs['object-fit'].present?};")
      else
        case attachment.blob.content_type
        when "application/pdf"
          ActionController::Base.helpers.image_tag("Picto_pdf.png", class: attrs[:picto_class], style: "max-height: 100%; max-width: 100%; width: #{attrs[:width] if attrs[:width].present?}; height: #{attrs[:height] if attrs[:height].present?}; object-fit: #{attrs['object-fit'] if attrs['object-fit'].present?};")
        when "application/vnd.ms-powerpoint", "application/vnd.openxmlformats-officedocument.presentationml.presentation"
          ActionController::Base.helpers.image_tag("Picto_ppt.png", class: attrs[:picto_class], style: "max-height: 100%; max-width: 100%; width: #{attrs[:width] if attrs[:width].present?}; height: #{attrs[:height] if attrs[:height].present?}; object-fit: #{attrs['object-fit'] if attrs['object-fit'].present?};")
        when "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          ActionController::Base.helpers.image_tag("Picto_excel.png", class: attrs[:picto_class], style: "max-height: 100%; max-width: 100%; width: #{attrs[:width] if attrs[:width].present?}; height: #{attrs[:height] if attrs[:height].present?}; object-fit: #{attrs['object-fit'] if attrs['object-fit'].present?};")
        when "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
          ActionController::Base.helpers.image_tag("Picto_word.png", class: attrs[:picto_class], style: "max-height: 100%; max-width: 100%; width: #{attrs[:width] if attrs[:width].present?}; height: #{attrs[:height] if attrs[:height].present?}; object-fit: #{attrs['object-fit'] if attrs['object-fit'].present?};")
        else
          ActionController::Base.helpers.image_tag("Picto_generique.png", class: attrs[:picto_class], style: "max-height: 100%; max-width: 100%; width: #{attrs[:width] if attrs[:width].present?}; height: #{attrs[:height] if attrs[:height].present?}; object-fit: #{attrs['object-fit'] if attrs['object-fit'].present?};")
        end
      end
    end
  end

  private

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  # def content_type
  #   self.attachment.blob.content_type
  # end

  # def main_content_type
  #   content_type.split("/").first
  # end

  def set_format
    self.format = attachments.map(&:content_type).map { |content_type|
      case content_type
      when "image/gif", "image/png", "image/jpeg"
        "Image"
      when "video/mp4", "video/quicktime"
        "Vidéo"
      when "application/pdf"
        "Pdf"
      when "application/vnd.ms-powerpoint", "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        "Power-Point"
      when "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "Excel"
      when "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "Word"
      else
        "Autre"
      end
    }.uniq.sort.reverse.join(', ')
  end

  def no_duplicate_filename
    return false if attachments.blank?
    return false if attachments.count == attachments.map{ |attachment| attachment.filename.to_s }.uniq.count
    errors.add(:attachments, :no_duplicate_filename)
  end
end
