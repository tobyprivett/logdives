Feature: User preferences
As a User
I want to set some preferences
In order to enhance my log dive experience

Background:
Given I am logged in
And I am on the home page

Scenario: Setting a username
Given I follow "Settings"
And fill in "user_name_accessor" with "toby2"
And I press "Save username"
Then I should see "Logged in as toby2"

Scenario: Changing a password
Given I follow "Settings"
And fill in "New password" with "passw0rd"
And fill in "New password confirmation" with "passw0rd"
And I press "Save username"
Then I should see "account has been updated"


Scenario: Viewing email address
Given I follow "Settings"
And I should see "Your email address is example@example.com"