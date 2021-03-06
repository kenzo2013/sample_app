require 'spec_helper'


describe UsersController do
	render_views

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
    it "devrait avoir le titre adéquat" do
	get 'new'
	response.should have_selector("title", :content => "Inscription")
    end
  end
  
  describe "GET 'show'" do
	before(:each) do
		@user = FactoryGirl.create(:user)
	end
	it "devrait réussir" do
		get :show, :id => @user
		response.should be_success
	end
	it "devrait trouver le bon utilisateur" do
		get :show, :id => @user
		assigns(:user).should == @user
	end
	it "devrait inclure le nom de l'utilisateur" do
		get :show, :id => @user
		response.should have_selector("h1", :content => @user.name)
	end
	it "devrait avoir une image de profil" do
		get :show, :id => @user
		response.should have_selector("h1>img", :class => "gravatar")
	end
  end
  
  describe "POST 'create'" do
		describe "échec" do
			before(:each) do
			@attr = { :nom => "", :email => "", :password => "", :password_confirmation => "" }
			end
			it "ne devrait pas créer d'utilisateur" do
				lambda do
					post :create, :user => @attr
					end.should_not change(User, :count)
			end
			it "devrait avoir le bon titre" do
				post :create, :user => @attr
				response.should have_selector("title", :content => "Inscription")
			end
			it "devrait rendre la page 'new'" do
				post :create, :user => @attr
				response.should render_template('new')
			end
		end
		describe "success" do
			before(:each) do
			@attr = {:nom => "New User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar"}
			end
			it "devrait créer un utilisateur" do
				lambda do
				post :create, :user => @attr
				end.should change(User, :count).by(1)
			end
			it "devrait rediriger vers la page d'affichage de l'utilisateur" do
				post :create, :user => @attr
				response.should redirect_to(user_path(assigns(:user)))
			end
			it "devrait avoir un message de bienvenue" do
				post :create, :user => @attr
				flash[:success].should =~ /Bienvenue dans l'Application Exemple/i
			end
		end
	describe "success" do
		it "devrait identifier l'utilisateur" do
		post :create, :user => @attr
		controller.should be_signed_in
		end
		
   end
   
   describe "GET 'edit'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end
		it "devrait réussir" do
			get :edit, :id => @user
			response.should be_success
		end
		it "devrait avoir le bon titre" do
			get :edit, :id => @user
			response.should have_selector("title", :content => "Édition profil")
		end
		it "devrait avoir un lien pour changer l'image Gravatar" do
			get :edit, :id => @user
			gravatar_url = "http://gravatar.com/emails"
			response.should have_selector("a", :href => gravatar_url, :content => "changer")
		end
  end



describe "PUT 'update'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end
	describe "Échec" do
		before(:each) do
			@attr = { :email => "", :name => "", :password => "", :password_confirmation => "" }
		end
		it "devrait retourner la page d'édition" do
			put :update, :id => @user, :user => @attr
			response.should render_template('edit')
		end
		it "devrait avoir le bon titre" do
			put :update, :id => @user, :user => @attr
			response.should have_selector("title", :content => "Édition profil")
		end
	end
	describe "succès" do
		before(:each) do
			@attr = { :name => "New Name", :email => "user@example.org", :password => "barbaz", :password_confirmation => "barbaz"}
		end
		it "devrait modifier les caractéristiques de l'utilisateur" do
			put :update, :id => @user, :user => @attr
				@user.reload
				@user.name.should == @attr[:name]
				@user.email.should == @attr[:email]
		end
		it "devrait rediriger vers la page d'affichage de l'utilisateur" do
			put :update, :id => @user, :user => @attr
			response.should redirect_to(user_path(@user))
		end
		it "devrait afficher un message flash" do
			put :update, :id => @user, :user => @attr
			flash[:success].should =~ /actualisé/
		end
	end
end

describe "authentification des pages edit/update" do
		before(:each) do
			@user = FactoryGirl.create(:user)
		end
	describe "pour un utilisateur non identifié" do
		it "devrait refuser l'acccès à l'action 'edit'" do
			get :edit, :id => @user
			response.should redirect_to(signin_path)
		end
		it "devrait refuser l'accès à l'action 'update'" do
			put :update, :id => @user, :user => {}
			response.should redirect_to(signin_path)
		end
	end
	describe "pour un utilisateur identifié" do
		before(:each) do
			wrong_user = FactoryGirl.create(:user, :email => "user@example.net")
			test_sign_in(wrong_user)
		end
		it "devrait correspondre à l'utilisateur à éditer" do
			get :edit, :id => @user
				response.should redirect_to(root_path)
		end
		it "devrait correspondre à l'utilisateur à actualiser" do
			put :update, :id => @user, :user => {}
			response.should redirect_to(root_path)
		end
	end
end



describe "GET 'index'" do
	describe "pour utilisateur non identifiés" do
		it "devrait refuser l'accès" do
			get :index
			response.should redirect_to(signin_path)
			flash[:notice].should =~ /identifier/i
		end
	end
	describe "pour un utilisateur identifié" do
		before(:each) do
			@user = test_sign_in(FactoryGirl.create(:user))
			second = FactoryGirl.create(:user, :email => "another@example.com")
			third = FactoryGirl.create(:user, :email => "another@example.net")
			@users = [@user, second, third]
			30.times do
			@users << FactoryGirl.create(:user, :email => FactoryGirl.create.next(:email))
			end
		end
		it "devrait réussir" do
			get :index
			response.should be_success
		end
		it "devrait avoir le bon titre" do
			get :index
			esponse.should have_selector("title", :content => "Liste des utilisateurs")
		end
		it "devrait avoir un élément pour chaque utilisateur" do
			get :index
			@users[0..2].each do |user|
			response.should have_selector("li", :content => user.name)
		end
		end
		it "devrait paginer les utilisateurs" do
			get :index
			response.should have_selector("div.pagination")
			response.should have_selector("span.disabled", :content => "Previous")
			response.should have_selector("a", :href => "/users?page=2", :content => "2")
			response.should have_selector("a", :href => "/users?page=2", :content => "Next")
		end
	end
end



end
end
