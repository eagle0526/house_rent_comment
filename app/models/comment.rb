class Comment < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :house

  # 一個留言，有很多被按讚
  has_many :like_states, as: :likeable

  # 至少 1 個字
  validates :content, presence: true, length: { minimum: 1 }

  # 留言自聯結
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :comments, foreign_key: :parent_id

  # content 的 rich editor 設定
  # has_rich_text :content  
end
