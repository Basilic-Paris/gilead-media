class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :password_expirable, :password_archivable

  has_many :shared_lists, dependent: :destroy
  has_many :shared_documents, dependent: :destroy
  has_many :shared_folders, dependent: :destroy
  has_many :document_shared_lists, through: :shared_lists
  has_many :folder_shared_lists, through: :shared_lists
  has_many :custom_mails, through: [:shared_folders, :shared_documents, :shared_lists]

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
