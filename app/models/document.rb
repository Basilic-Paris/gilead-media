class Document < ApplicationRecord
  validates :title, presence: true
  validates :language, presence: true, inclusion: { in: %w[FR EN] }
end
