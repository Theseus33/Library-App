class SessionsController < ApplicationController


    def new
        @user = User.new
    end
#creates a new user token requires a unique username and password
    def create
        username = user_params[:username]
        password = user_params[:password]

        user = User.find_from_credentials(username, password)   
#as per Ari's lesson if user is signed it will flash a message and redirect to users page
#otherwise it will flash an error and re-show the create page
        if user
            sign_in(user)
            flash[:notice] = "#{username}, You are signed in!"
            redirect_to users_path
        else
            flash[:error] = "User not found"
            @user = User.new(username: username)
            render :new
        end
    end
#destroys the users sign in token to close the session
    def destroy
        sign_out 
        flash[:notice] = 'You signed out'
        redirect_to root_path
    end

    private
#defines users parameters
    def user_params
        params.require(:user).permit(:username, :password)
    end

end
