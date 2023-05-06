class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_one_attached :profile_image
  
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  def get_profile_image 
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
    #profile_imageがない時は'no_image.jpg'を表示する
  end
  
  def follow(user)
    relationships.create(followed_id: user.id)
    #relationshipsのcreateが動いたときにrelationshipモデルのfollowed_idにuser.idを保存する
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
    #上記で保存したのを削除する。
  end

  def following?(user)
    followings.include?(user)
    #配列 followings 内に、引数として渡された user が含まれているかどうかを判定するためのコード
  end
  
  def self.looks(search, word)
    if search == "perfect_match"#検索機能の完全一致
      @user = User.where("name LIKE?", "#{word}")
      #完全一致以外の検索方法は、#{word}の前後(もしくは両方に)、__%__を追記することで定義することができます。
    elsif search == "forward_match"#検索機能の前方一致
      @user = User.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"#検索機能の後方一致
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"#検索機能の部分一致
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end
end
