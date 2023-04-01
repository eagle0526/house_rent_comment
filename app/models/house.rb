class House < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :user
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :normal, resize_to_limit: [300, 300]
  end

end
