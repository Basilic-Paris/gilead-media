class SharedDocument < ApplicationRecord
  belongs_to :document
  belongs_to :shared_list
end
