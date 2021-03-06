class SharedFolder < ApplicationRecord
  include SharedFolderStateMachine
  include ContactHelper

  belongs_to :folder
  belongs_to :user
  has_many :contacts, as: :contactable, dependent: :destroy

  validates :code, presence: true, uniqueness: true, length: { is: 16 }
  validates :contacts, presence: true
  validates :download, inclusion: { in: [true, false] }
end
