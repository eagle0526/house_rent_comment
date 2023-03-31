class House < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :user
  has_many_attached :images
end
