Feature:
As a visitor
I want to sign in with facebook
In order to make the most of the site

@omniauth_test_success_existing_user
  Scenario: A new user successfully signs in with Facebook
    Given I am logged in
    And I follow "Logout"
    And I follow "facebook_connect"
    Then I should be on the new dive page
    And I should see "Logged in as Toby"

@omniauth_test_success_new_user
  Scenario: A new user successfully signs in with Facebook
    Given I am on the homepage
    And I follow "facebook_connect"
    Then I should be on the new dive page
    And I should see "Logged in as email@example.com"

@omniauth_test_failure
  Scenario: A user unsuccessfully signs in with Facebook
    Given I am on the homepage
    And I follow "facebook_connect"
    Then I should be on the login page