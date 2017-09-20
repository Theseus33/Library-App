class ReviewsController < ApplicationController
    #before any method is carried out a book and review will be searched for
    #based on private methods found below
    before_action :find_book
    before_action :find_review, only: [:edit, :update, :destroy] 

    #sets a new review
    def new
        @review = Review.new
    end

    #creation of new review based on userid if successful the individual book
    #that has been rated will show otherwise a review view will be shown
    def create
        @review = Review.new(review_params)
        @review.book_id = @book.id
        @review.user_id = current_user.id

        if @review.save
            redirect_to book_path(@book)
        else
            render 'new'
        end
    end

    def edit
    end

    #change a review and redirects to the book that the review was changed for
    #if unsuccessful then rerenders the edit review view
    def update
        if @review.update(review_params)
            redirect_to book_path(@book)
        else
            render 'edit'
        end
    end

    #allows for a review to be deleted
    def destroy
        @review.destroy
        redirect_to book_path(@book)
    end
    
    private

    #defines parameters for a review
        def review_params
            params.require(:review).permit(:rating, :comment)
        end
    #finds book via id number
        def find_book
            @book = Book.find(params[:book_id])
        end
    #finds review via id number
        def find_review
            @review = Review.find(params[:id])
        end
end
