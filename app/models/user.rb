class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :password_expirable, :password_archivable

  has_many :shared_lists
  has_many :shared_documents
  has_many :shared_folders
  has_many :document_shared_lists, through: :shared_lists
  has_many :folder_shared_lists, through: :shared_lists

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
