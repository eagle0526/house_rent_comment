class Comment < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :house

  # 一個留言，有很多被按讚
  has_many :like_states, as: :likeable

  validates :content, presence: true, length: { minimum: 5 }

  # 留言自聯結
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :comments, foreign_key: :parent_id
end
