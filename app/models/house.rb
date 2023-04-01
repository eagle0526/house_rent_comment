class House < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :user
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]    
  end

end
