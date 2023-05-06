class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  #titleが空の場合は保存できない
  validates :body,presence:true,length:{maximum:200}
  #lengthは文字数の設定。今回は最大200文字の設定
  def favorited_by?(user)
    #モデルのインスタンスが、引数で与えられたuserによってお気に入りに登録されているかどうかを判定するメソッド
    favorites.exists?(user_id: user.id)
    #favoritesモデルの中のuser_idの中にuser.idがあるか判定する
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
end
