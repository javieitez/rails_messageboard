class UsersController < ApplicationController
  
  def index
  end

  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Your account has been created. Welcome aboard!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  private

        def user_params
            params.require(:user).permit(:name, :username, :email, :password,
                                         :password_confirmation)
        end
        
end
