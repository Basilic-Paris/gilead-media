class SharedFolder < ApplicationRecord
  include SharedFolderStateMachine

  belongs_to :folder

  validates :shared_list, uniqueness: { scope: :folder }
end
