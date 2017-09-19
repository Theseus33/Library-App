class UsersController < ApplicationController

    def index
        @user.count = User.count
    end
    
    def new 
        @user = User.new
    end

    def create 
        @user = User.new(create_params)

        if  user.save
            sign_in(user)
            flash[:notice] = 'Welcome to Your Library App'
            redirect_to users_path
        else
            errors = user.errors.full_messages
            flash[:error] = @user.errors.join(', ')
            @user = User.new(username: create_params[:username])
            render :new
        end
    end

    def show
        @user = User.find(params[:id])
    end

    private

    def create_params
        params.require(:user).permit(:username, :password)
    end

end
