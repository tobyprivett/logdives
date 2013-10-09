Feature: Convert units
In order to log my dive depth in metres
As a I user
I want to convert the units


Scenario: Adding an imperial dive and viewing in metric
Given I am logged in
And I am on the home page
And I follow "Settings"
And I follow "imperial"
And I follow "Log a dive"
And I fill in "Dive site" with "Dahab"
And I fill in "Date" with "2011-01-01"
And I press "Save"
And I fill in "dive_max_depth_amount" with "130"
And I select "feet" from "dive_depth_unit"
Then I press "Save"
And I follow "My Dives"
And I should see "130.0 ft"
When I follow "Settings"
And I follow "metric"
And I follow "My Dives"
Then I should see "39.6 m"
