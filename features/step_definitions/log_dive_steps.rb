Given /^I upload a suunto file$/ do
  attach_file "File", "#{Rails.root}/test/assets/suunto_sample.SDE"
  click_button("Upload")
end

Given /^I upload a profile picture$/ do
  attach_file "user_avatar", "#{Rails.root}/test/assets/test_image.png"
end

Given /^I upload an invalid file$/ do
  attach_file "File", "#{Rails.root}/test/assets/invalid_file"
  click_button("Upload")
end

Given /^I am logging a tec dive with valid attributes$/ do
  login
  And "I am on the dives page"
  click_link "Log a dive"
  select("Technical", :from => "Dive type")

  fill_in "dive_location", :with => "Blue hole"
  click_button "Save"
  fill_in "dive_dive_date", :with => Date.today
  fill_in "dive_max_depth_amount", :with => "30"
  fill_in "Total dive time", :with => "44"

end


Given /^I have logged a dive$/ do
  Given "I am on the dives page"
  click_link "Log a dive"
  fill_in "dive_location", :with => "Blue hole"
  fill_in "dive_dive_date", :with => Date.today
  click_button "Save"

end
