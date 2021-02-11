class Contact < ApplicationRecord
  belongs_to :contactable, polymorphic: true

  validates :email, uniqueness: { scope: :contactable }
  validates :email, email: { mode: :strict }
end
