Feature:
As a User
I want to register
In order to blah

Background:
Given I am on the home page
And I should see "Make logdives.com your online log book"
And I follow "Registering"
And I should not see "Make logdives.com your online log book"
And I fill in "Email" with "moi@example.com"
And I fill in "Username" with "moi_aussi"
And I fill in "Password" with "pppppppp"
And I fill in "Password confirmation" with "pppppppp"
And I am human
And  I press "Register"


Scenario:
Then I should see "receive an email with instructions"
And "moi@example.com" should receive an email
When I open the email
And I click the first link in the email
And I should be on the new dive page

Scenario: Resend instructions
Then I follow "Didn't receive confirmation email?"
And I fill in "Email" with "moi@example.com"
And I press "Resend confirmation email"
Then I should see "receive an email with instructions"
And "moi@example.com" should receive 2 emails