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
response.should have_selector('title', :content => "Submit")

end
it "devrait avoir le bon lien sur le layout" do
	visit root_path
	click_link "About"
	response.should have_selector('title', :content => "About")
	click_link "Help"
	response.should have_selector('title', :content => "Help")
	click_link "Contact"
	response.should have_selector('title', :content => "Contact")
	click_link "Home"
	response.should have_selector('title', :content => "Home")
	click_link "Submit"
	response.should have_selector('title', :content => "Submit")
end
end
