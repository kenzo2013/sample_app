class UsersController < ApplicationController
  def new
  @titre = "Inscription"
  end
  def show
	@user = User.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
    def actor_params
      params.require(:user).permit(:name, :email)
    end
end
