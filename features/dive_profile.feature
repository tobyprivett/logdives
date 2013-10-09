Feature: Dive Profile
As a User
I want to enter a dive profile
In order to visualise the dive

Background:
Given I am logging a tec dive with valid attributes

Scenario: Simple profile
When I fill in "Time" with "45"
And I fill in "Depth" with "6"
And I fill in "Description" with "Safety stop"
And press "Save"
Then I should see "updated"