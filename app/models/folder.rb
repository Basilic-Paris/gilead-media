class Folder < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
