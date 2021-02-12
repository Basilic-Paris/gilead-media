class SharedFolder < ApplicationRecord
  include SharedFolderStateMachine

  belongs_to :folder
  has_many :contacts, as: :contactable

  validates :code, presence: true, uniqueness: true, length: { is: 16 }
  validates :contacts, presence: true
end
