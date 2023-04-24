class House < ApplicationRecord
  acts_as_paranoid
  # is_impressionable
  is_impressionable :counter_cache => true, :column_name => :houses_count

  belongs_to :user
  
  # 圖片
  has_many_attached :images do |attachable|

    # 每張圖是固定size
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :normal, resize_to_limit: [300, 300]

    # 每張圖會依照比例縮放
    attachable.variant :standard, resize_to_fill: [1200, 900]
    attachable.variant :first, resize_to_fill: [1200, 904]
  end

  # 圖片上傳限制
  validates :images, attached: true, size: {less_than: 1.megabytes, message: '不能超過1MB'} 
  validates :title, presence: true


  # 一個房子，有很多的評論
  has_many :comments
  has_many :be_user_commented, through: :comments, source: :house

  # 一個房子，有很多被按讚
  has_many :like_states, as: :likeable

  # description 的 rich editor 設定
  has_rich_text :description



  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # 原本是input.to_s.parameterize，但是parameterize只支援英文跟數字，所以改用babosa的to_slug
  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end

  # 定義slug_candidates，預設會找第一個，如果有重複的title就會找第二個（title-description），最後才會生成亂序
  def slug_candidates
    [
      :title,
      [:title, :description]
    ]
  end  


  



end
