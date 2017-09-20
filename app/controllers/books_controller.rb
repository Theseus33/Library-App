class BooksController < ApplicationController
    before_action :find_book, only: [:show, :edit, :update, :destroy]

    
    #index view shows books in a descending order by creation
    #also allows to show books via the drop down genre selector
    def index
        if  params[:category].blank?
            @books = Book.all.order("created_at DESC")
        else
            @category_id = Category.find_by(name: params[:category]).id
            @books = Book.where(:category_id => @category_id).order("created_at DESC")
        end
    end

    #show view religates unrated books to show at 0 stars by default
    #for the avg rating otherwise the ratings will be averaged
	def show
		if @book.reviews.blank?
			@average_review = 0
		else
			@average_review = @book.reviews.average(:rating).round(2)
		end
	end

    #new book creation and relegated to categories
    def new 
        @book = current_user.books.build
        @categories = Category.all.map{ |f| [f.name, f.id] }
    end

    #create books via private book parameters described below
    #if a book is successfully saved then the all books page
    #will render otherwise create screen will show again
    def create 
        @book = current_user.books.build(book_params)
        @book.category_id = params[:category_id]

        if @book.save
            redirect_to books_path
        else 
            render 'new'
        end
    end

    #allows edit 
    def edit
        @categories = Category.all.map{ |c| [c.name, c.id] }
    end

    #allows books to be edited and updated and if successful
    #it will rerender the single book view otherwise the edit
    #view will be displayed
    def update
        @book.category_id = params[:category_id]
        if @book.update(book_params)
            redirect_to book_path(@book)
        else
            render 'edit'
        end
    end

    #delete a book and render all books page
    def destroy
        @book.destroy
        redirect_to books_path
    end

    private
    #defines parameters for a book
    def book_params
        params.require(:book).permit(:title, :description, :author, :category_id, :book_img)
    end
    #searches for individual book via id number
    def find_book
        @book = Book.find(params[:id])
    end

end