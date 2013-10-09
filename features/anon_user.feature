Feature:
As an Anon User
I want to be nagged
In order that I choose a username


Scenario: Signing in and Logging a dive
Given I am logged in as anon
And I follow "Log a dive"
And I am on the new dive page
And I should see "choose your username"
And I follow "choose your username"
And I fill in "user_name_accessor" with "moiaussi"
And I press "Save username"
And I follow "Log a dive"
And I am on the new dive page
And I should not see "choose your username"