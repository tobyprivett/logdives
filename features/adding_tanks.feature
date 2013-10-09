Feature: Adding tanks
In order to record my tank pressure
As a User
I want to add tanks to my dive


Scenario: Adding a single tank of air
Given I am logging a tec dive with valid attributes
And I fill in "Start" with "200"
And I fill in "End" with "70"
And I select "bar" from "dive_tanks_attributes_0_pressure_unit"
And I press "Save"
Then I should see "updated"

Scenario: Adding a single tank of nitrox
Given I am logging a tec dive with valid attributes
And I fill in "Start" with "200"
And I fill in "End" with "70"
And I select "Nitrox" from "dive_tanks_attributes_0_mix_type"
And I select "bar" from "dive_tanks_attributes_0_pressure_unit"
And I fill in "dive_tanks_attributes_0_o2" with "32"
And I press "Save"
Then I should see "updated"

Scenario: Adding a single tank of trimix
Given I am logging a tec dive with valid attributes
And I fill in "Start" with "200"
And I select "Trimix" from "dive_tanks_attributes_0_mix_type"
And I fill in "End" with "70"
And I fill in "dive_tanks_attributes_0_o2" with "18"
And I fill in "dive_tanks_attributes_0_he" with "35"
And I fill in "dive_tanks_attributes_0_volume" with "80"
And I select "cu. ft." from "dive_tanks_attributes_0_volume_unit"
And I select "bar" from "dive_tanks_attributes_0_pressure_unit"
And I press "Save"
Then I should see "updated"

