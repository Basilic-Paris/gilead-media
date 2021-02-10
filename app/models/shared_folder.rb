class SharedFolder < ApplicationRecord
  belongs_to :folder
  belongs_to :shared_list
end
