class BooksController < ApplicationController
  def index
  end

  def show
    @books = Book.find(params[:id])
    @user = @books.user
    @book = Book.new
    @book_comment = BookComment.new
  end

  def edit
  end
  
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end
  
  private

  def book_params
    params.require(:book).permit(:title,:body)
  end
  
end
