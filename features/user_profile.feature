Feature: User profile
As a User
I want to complete a profile
In order to show others what I do


Scenario:
Given I am logged in
And I have logged a dive
And I am on the home page
And I follow "My Dives"
And I follow "Edit your profile"
Then I fill in "user_bio" with "A long time ago"
And I upload a profile picture
When I press "Save"
And I should see "A long time ago"
