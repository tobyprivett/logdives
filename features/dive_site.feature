Feature: Dive sites
As a User
I want to add add a dive site
In order to log a dive there

Scenario: in isolation / by country
Given I am on the new dive site page
And I fill in "name" with "Cenote Calimba"
And I select "Mexico" from "Country"
And I press "Save"
Then I should see "Dive site added"
And the field "Latitude" should contain "12345"
And the field "Longitude" should contain "54321"
And I should see the location on a map


@wip
Scenario: By address
And I am on the new dive page
And I should not see "We do not know"
When I fill in "dive_location" with "Cenote Calimba"
And I press "Save"
And I should see "We do not know 'Cenote Calimba'"
And I select "Mexico" from "Country"
And I press "Save"
Then the field "Dive site" should contain "Cenote Calimba, Mexico"

