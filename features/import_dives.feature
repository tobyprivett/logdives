Feature:
In order to import my dive data
As a user
I want to upload a file


Scenario: Upload and extract a zip file
Given I am logged in
And I am on the new user upload page
And I upload a suunto file
Then I should see "7 dives added"


Scenario: Upload an invalid file
Given I am logged in
And I am on the new user upload page
And I upload an invalid file
Then I should not see "The following dives were uploaded"