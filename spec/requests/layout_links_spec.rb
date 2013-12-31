require 'spec_helper'


describe "LayoutLinks" do
		it "devrait trouver une page Accueil à '/'" do
			get '/'
			response.should have_selector('title', :content => "Home")
		end
		it "devrait trouver une page Contact at '/contact'" do
			get '/contact'
			response.should have_selector('title', :content => "Contact")
		end
		it "should have an À Propos page at '/about'" do
			get '/about'
			response.should have_selector('title', :content => "About")
		end
		it "devrait trouver une page aide à '/help'" do
			get '/help'
			response.should have_selector('title', :content => "Help")
		end
		it "devrait avoir une page d'inscription à '/signup'" do
			get '/signup'
			response.should have_selector('title', :content => "Inscription")
		end

	describe "quand pas identifié" do
		it "doit avoir un lien de connexion" do
			visit root_path
			response.should have_selector("a", :href => signin_path, :content => "S'identifier")
		end
	end
	describe "quand identifié" do
		before(:each) do
		@user = FactoryGirl.create(:user)
		visit signin_path
		fill_in :email, :with => @user.email
		fill_in "Mot de passe", :with => @user.password
		click_button
		end
		it "devrait avoir un lien de déconnexion" do
			visit root_path
			response.should have_selector("a", :href => signout_path, :content => "Déconnexion")
		end
		it "devrait avoir un lien vers le profil" do
			visit root_path
			response.should have_selector("a", :href => user_path(@user), :content => "Profil")
		end
	end
end

