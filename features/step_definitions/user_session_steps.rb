def user
  @user ||= Factory :confirmed_user
end

def login
  user
  visit path_to("the login page")
  fill_in "Email", :with => @user.email
  fill_in "Password", :with => @user.password
  click_button "Login"
end

def stub_captcha
  User.any_instance.stubs(:bypass_humanizer).returns(true)
end

Given /^I am human$/ do
  stub_captcha
end


Then /^I logout$/ do
  visit '/users/sign_out'
end

Given /^I am a registered user$/ do
  user
end

Given /^I am logged in$/ do
  login
end


Given /^I am logged in as anon$/ do
  @user = Factory :anon_user
  visit path_to("the login page")
  fill_in "Email", :with => @user.email
  fill_in "Password", :with => @user.password
  click_button "Login"
end


Then /^I should be logged in as "(.*)$/ do |email|
  email.should =~ /#{@user.email}/
end