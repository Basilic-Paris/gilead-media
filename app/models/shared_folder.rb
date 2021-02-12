class SharedFolder < ApplicationRecord
  belongs_to :folder

  validates :shared_list, uniqueness: { scope: :folder }
end
