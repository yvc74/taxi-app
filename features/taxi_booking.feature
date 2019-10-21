Feature: Taxi booking
  As a customer
  Such that I go to destination
  I want to arrange a taxi ride

  Scenario: Booking via STRS' web page (with confirmation)
    Given the following taxis are on duty
          | username | location	     | status    |
          | peeter88 | Juhan Liivi 2 | busy      |
          | juhan85  | Kalevi 4      | available |
    And I want to go from "Juhan Liivi 2" to "Muuseumi tee 2"
          And I open STRS' web page
          And I enter the booking information
          When I submit the booking request
          Then I should receive a confirmation message

  Scenario: Booking via STRS' web page (with rejection)
      Given the following taxis are on duty
          | username  | location  | status |
          | juhan85   | Kaubamaja | busy   |
          | peeter88  | Kaubamaja | busy   |
      And I want to go from "Liivi 2" to "Lõunakeskus"
          And I open STRS' web page
          And I enter the booking information
          When I submit the booking request
          Then I should receive a rejection message