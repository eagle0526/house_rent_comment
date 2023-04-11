class LikeState < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true  
  

  # 房子點讚
  scope :house_state_true, -> { where(state: true, likeable_type: "House") }
  # 房子倒讚
  scope :house_state_false, -> { where(state: false, likeable_type: "House") }

  def self.house_true_count
    self.house_state_true.size
  end
  def self.house_state_count
    self.house_state_false.size
  end

end
