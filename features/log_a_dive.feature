Feature:
In order to remember my dive
As a user
I want to log it

@javascript
Scenario: Rec Dive, changes to Tec dive, then deletes it

Given I am logged in
And I have logged a dive
And I am on the dives page
And I follow "Log a dive"
Then I fill in "dive_location" with "Blue Hole, Dahab"
And I fill in "Date" with "2011-11-11"
And I press "Save"
And I follow "hide_profile"
And I follow "multi-level dive"
And I fill in "Depth" with "18"
And I fill in "Time" with "15"
And I press "Save"


And I select "Technical" from "Dive type"
And I follow "Reload the page"
Then I should see "updated"

And I follow "Delete this dive"
And I confirm popup
And I should be on the dives page
And I should see "The dive has been deleted"


Scenario: Tec Dive
Given I am logged in
And I am on the dives page
And I follow "Log a dive"
And I select "Technical" from "Dive type"
Then I fill in "Dive site" with "Blue Hole, Dahab"
And I fill in "Date" with "2011-11-11"
And I press "Save"
And I fill in "dive_max_depth_amount" with "30"
And I fill in "Total dive time" with "20"
And I press "dive_submit"
Then I should see "updated"
