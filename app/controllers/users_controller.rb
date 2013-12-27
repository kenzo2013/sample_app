class UsersController < ApplicationController
  def new
  @titre = "Inscription"
  end
  def show
	@user = User.find(params[:id])
	@titre = @user.name
  end
  # Never trust parameters from the scary internet, only allow the white list through.
    def actor_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
