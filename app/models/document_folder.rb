class DocumentFolder < ApplicationRecord
  belongs_to :document
  belongs_to :folder
end
