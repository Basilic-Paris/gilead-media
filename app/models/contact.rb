class Contact < ApplicationRecord
  belongs_to :shared_list

  validates :email, uniqueness: { scope: :shared_list }
  validates :email, email: { mode: :strict }
end
