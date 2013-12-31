
# En utilisant le symbole ':user', nous faisons que
# Factory Girl simule un modèle User.
FactoryGirl.define do
factory :user do |user|

 user.name 		    "Michael Hartl"
 user.email 		    "mhartl@example.com"
 user.password 		    "foobar"
 user.password_confirmation "foobar"
	
end
sequence :email do |n|
 "person-#{n}@example.com"
end
end
