class UsersController < ApplicationController
  def new
  	@titre = "Inscription"
  	@user = User.new
  end
  def show
	@user = User.find(params[:id])
	@titre = @user.name
  end
  def create
 	 @user = User.new(user_params)
    if @user.save
    	flash[:success] = "Bienvenue dans l'Application Exemple!"
  	redirect_to @user
  	  else
  		@titre = "Inscription"
  		render 'new'
     end
  end
  # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
