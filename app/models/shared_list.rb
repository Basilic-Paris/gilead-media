class SharedList < ApplicationRecord
  include SharedListStateMachine
  include ContactHelper

  attr_accessor :validate_custom_mail

  belongs_to :user
  has_many :document_shared_lists, dependent: :destroy
  has_many :documents, through: :document_shared_lists
  has_many :folder_shared_lists, dependent: :destroy
  has_many :folders, through: :folder_shared_lists
  has_many :contacts, as: :contactable, dependent: :destroy
  has_one :custom_mail, as: :mailable, dependent: :destroy

  validates :title, presence: true#, uniqueness: { scope: :user }
  validates :code, presence: true, uniqueness: true, length: { is: 16 }
  validates :download, inclusion: { in: [true, false] }
  validates :contacts, presence: true, on: :update
  validates :custom_mail, presence: true, if: :validate_custom_mail?

  accepts_nested_attributes_for :custom_mail

  scope :ordered_by_title, -> { order('lower(title)') }

  private

  def validate_custom_mail?
    validate_custom_mail == true
  end
end
