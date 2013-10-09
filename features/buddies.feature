Feature: Dive buddies
As a User
I want to add buddies to the dive
In order to get their confirmation

@javascript
Scenario: Buddy confirms dive, then views his version
Given I am logging a tec dive with valid attributes
When I fill in "Username or Email" with "buddy-diver@example.com"
And I select "Buddy" from "dive_buddies_attributes_0_role"
And I press "Save"
And I should see "buddy-diver@example.com"
And no emails have been sent
Then I follow "Request confirmation"
Then I should see "Confirmation request sent to buddy-diver@example.com"
And I logout

And "buddy-diver@example.com" should receive an email
And I open the email
And I click the first link in the email
And I follow "Yes, I confirm this dive"
Then I follow "add this dive to your log."
And I should see "has been added to your log"

And I follow "edit_dive_link"
And the "Dive site" field should contain "Blue hole"
And the "Max depth" field should contain "30"
And the "Total dive time" field should contain "44"

@javascript
Scenario: Buddy rejects dive
Given I am logging a tec dive with valid attributes
When I fill in "Username or Email" with "buddy-diver@example.com"
And I select "Buddy" from "dive_buddies_attributes_0_role"
And I press "Save"
And I should see "buddy-diver@example.com"
And no emails have been sent
Then I follow "Request confirmation"
Then I should see "Confirmation request sent to buddy-diver@example.com"
And I logout

And "buddy-diver@example.com" should receive an email
And I open the email
And I click the first link in the email
And I follow "No, I do not confirm this dive"
And I confirm popup
Then I should see "You rejected this dive"
