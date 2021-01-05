class Document < ApplicationRecord
  include DatetimeHelper

  LANGUAGES = %w[FR EN]

  validates :title, presence: true
  validates :language, presence: true, inclusion: { in: LANGUAGES }

  scope :validated, -> { where.not(validation_at: nil) }

  def validated?
    validation_at.present?
  end
end
