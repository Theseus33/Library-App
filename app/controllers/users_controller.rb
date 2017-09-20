class UsersController < ApplicationController
#premethod actions which checks if user is signed in or not
    before_action :ensure_signed_out, only: [:new, :create]
    before_action :ensure_signed_in, only: [:show, :index]

    def new 
        @user = User.new
    end
#create a new user with respect to the parameters set in private methods
#flashes welcome message
    def create 
        @user = User.new(create_params)

        if @user.save
            sign_in(@user)
            flash[:notice] = 'Welcome to Your Library App'
            redirect_to users_path
        else
            flash[:error] = @user.errors.full_messages.join(', ')
            render :new
        end
    end
#defines all users
    def index
        @users = User.all 
    end
#defines user by id number 
    def show
        @user = User.find(params[:id])
    end

    private

    def create_params
        params.require(:user).permit(:username, :password)
    end

end
