class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  # 一個使用者有新增多的租屋 
  has_many :houses

  # 一個使用者，有很多的評論
  has_many :comments
  has_many :commented_houses, through: :comments, source: :house

  # 一個使用者，按很多留言/房子的讚/倒讚
  has_many :like_states

  # 一個使用者，有很多瀏覽房子的次數
  has_many :page_views

  # 使用者大頭貼
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [250, 250]
  end

  # 圖片上傳限制
  validates :avatar, size: {less_than_or_equal_to: 500.kilobytes, message: '不能超過500KB'} 
  validates :name, presence: true  


  # google登入方法
  def self.create_from_provider_data(provider_data)
    where(email: provider_data.info.email).first_or_create do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = provider_data.info.last_name
      user.provider = provider_data.provider
      user.uid = provider_data.uid
    end
   end      

  def self.from_omniauth(auth)
    # Case 1: Find existing user by facebook uid
    user = User.find_by_fb_uid( auth.uid )
    if user
      user.fb_token = auth.credentials.token
      user.save!
      return user
    end
    # Case 2: Find existing user by email
    existing_user = User.find_by_email( auth.info.email )
    if existing_user
      existing_user.fb_uid = auth.uid
      existing_user.fb_token = auth.credentials.token
      existing_user.save!
      return existing_user
    end
    # Case 3: Create new password
    user = User.new
    user.fb_uid = auth.uid
    user.fb_token = auth.credentials.token
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.name = auth.info.name
    user.save!
    return user
  end

  # 找到指定的house 
  def house_like_state(house)
    like_states.find_by(likeable_type: "House", likeable_id: house)
  end

  # 找到指定的comment
  def comment_like_state(comment)
    like_states.find_by(likeable_type: "Comment", likeable_id: comment)
  end


  # 以下三個方法是使用者的房屋排列用的

  # house 那邊有 ordered_by_comment_count 這個 scope，主要就是房屋要跟根據留言數做排序
  def houses_ordered_by_comment_count
    houses.ordered_by_comment_count
  end

  # house 那邊有 ordered_by_like_state_true_count 這個 scope，主要就是房屋要跟根據喜歡數做排序
  def houses_ordered_by_like_state_true_count
    houses.ordered_by_like_state_true_count
  end

  # house 那邊有 ordered_by_page_view_count 這個 scope，主要就是房屋要跟根據瀏覽量做排序
  def houses_ordered_by_page_view_count
    houses.ordered_by_page_view_count
  end

  
  # 以下四個方法是使用者介面的

  # 使用者有評論過的房子，並依照留言時間排序
  def comments_ordered_by_time
    comments.order(created_at: :desc).map(&:house).uniq
    # comments.order(created_at: :desc).map(&:house).uniq = comments.order(created_at: :desc).map { |comment| House.find_by(id: house_id) }.uniq
  end

  # 使用者按過讚的房子
  def liked_ordered_by_time
    like_states.house_state_true.order(created_at: :desc).map { |like| House.find_by(id: like.likeable_id) }
  end

  # 使用者瀏覽過的房子
  def viewed_ordered_by_time
    page_views.where(impressionable_type: "House").order(created_at: :desc).pluck(:impressionable_id).uniq.map { |view_id| House.find_by(id: view_id) }
  end

  # 使用者發布的房子照發佈時間排序
  def published_ordered_by_time
    houses.order(id: :desc)
  end  

end
