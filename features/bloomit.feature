# encoding: utf-8

Feature: Bloomit mixin

  @math
  Scenario Outline: dlm_neighbor_slice asymptotically goes to 1
    Given the integer input is "<input>"
    When I call dlm_neighbor_slice on "input"
    Then the result is less than one
    Examples:
      | input             |
      | -10_000_000_000   |
      | -1_000_000_000    |
      | -1                |
      | 0                 |
      | 1                 |
      | 5                 |
      | 100               |
      | 100_500           |
      | 1_000_000         |
      | 1_000_000_000     |
      | 10_000_000_000    |

  @math
  Scenario Outline: dlm_neighbor_slice works on negatives
    Given the integer input is "<input>"
    When I call dlm_neighbor_slice on "input"
     And I call dlm_neighbor_slice on negative "input"
    Then the abs values are equal save for a sign
    Examples:
      | input             |
      | -10_000_000_000   |
      | -1_000_000_000    |
      | -1                |
      | 0                 |
      | 1                 |
      | 5                 |
      | 100               |
      | 100_500           |
      | 1_000_000         |
      | 1_000_000_000     |
      | 10_000_000_000    |

  @math
  Scenario: dlm_neighbor_slice decreases constantly on increased argument
    Given the integer inputs vary from 1 upto 30
    When I call dlm_neighbor_slice on neighbours
    Then the difference is decreasing

################################################################################

  @include
  Scenario Outline: Included into string should produce same colors for same strings
   Given the mixin is "include"d into "String"
    When I call bloomit on strings "<input1>" and "<input2>"
    Then I get same values for #to_color
    Examples:
      | input1            | input2            |
      | string            | string            |
      | string1           | string1           |
      | string2           | string2           |
      | Hedge             | Hedge             |
      | Redge             | Redge             |
      | Hodge             | Hodge             |
      | Hegde             | Hegde             |
      | Hedge1            | Hedge1            |
      | Hedge11           | Hedge11           |
      | HedgeHog          | HedgeHog          |
      | AAAAAAAAAAAAAAAAA | AAAAAAAAAAAAAAAAA |
      | e★★e★★e★★e★★e★★   | e★★e★★e★★e★★e★★   |
      | ★e★★e★★e★★e★★e★   | ★e★★e★★e★★e★★e★   |
      | ★★e★★e★★e★★e★★e   | ★★e★★e★★e★★e★★e   |

################################################################################
