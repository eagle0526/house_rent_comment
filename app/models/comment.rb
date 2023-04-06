class Comment < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :house

  validates :content, presence: true, length: { minimum: 5 }

  # 留言自聯結
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :comments, foreign_key: :parent_id
end
