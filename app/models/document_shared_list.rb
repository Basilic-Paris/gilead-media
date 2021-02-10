class DocumentSharedList < ApplicationRecord
  belongs_to :document
  belongs_to :shared_list

  validates :shared_list, uniqueness: { scope: :document }
end
