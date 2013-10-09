Feature: Browsing the dive feeder
As a Visitor
I want to browse the dive feed
In order to view a dive and a user profile

Background:
Given a dive exists with dive_no: "101"

Scenario:
And I am on the dive feed page
And I follow "Toby"
And I should see "Toby"

Scenario:
And I am on the login page
And I fill in "Email" with "example@example.com"
And I fill in "Password" with "password"
And I press "Login"
And I am on the dive feed page
And I follow "My Dive Site"
Then I should be on the edit dive page for 101-my-dive-site