class FolderSharedList < ApplicationRecord
  belongs_to :folder
  belongs_to :shared_list

  validates :shared_list, uniqueness: { scope: :folder }
end
