Given(/^the integer input is "(.*?)"$/) do |input|
  @input = input.to_i
end

Given(/^the mixin is "(.*?)"d into "(.*?)"$/) do |meth, klazz|
#  Kernel.const_get(klazz).send meth, Bloomit
end

Given(/^the integer inputs vary from (\d+) upto (\d+)$/) do |from, to|
  @inputs = (from.to_i...to.to_i).to_a
end

########################################################################################################################

When(/^I call dlm_neighbor_slice on "(.*?)"$/) do |variable|
  @result = (instance_variable_get "@#{variable}").dlm_neighbor_slice
end

When(/^I call bloomit on strings "(.*?)" and "(.*?)"$/) do |s1, s2|
  @s1, @s2 = s1, s2
end

When(/^I call dlm_neighbor_slice on negative "(.*?)"$/) do |variable|
  @negative_result = (- instance_variable_get("@#{variable}")).dlm_neighbor_slice
end

When(/^I call dlm_neighbor_slice on neighbours$/) do
  @results = @inputs.map { |i| [i, i.dlm_neighbor_slice] }.to_h
end

########################################################################################################################

Then(/^the result is less than one$/) do
  expect(@result).to be <= 1.0
end

Then(/^I get same values for \#to_color$/) do
  puts "Color of [#{@s1}] is: #{@s1.to_color}"
  expect(@s1.to_color).to eq(@s2.to_color)
end

Then(/^the abs values are equal save for a sign$/) do
  expect(@result.abs).to eq(@negative_result.abs)
  expect(@result).to eq(-@negative_result)
end

Then(/^the difference is decreasing$/) do
  puts @results
  expect(@inputs.any? { |i| @results[i - 1] && @results[i - 1] < @results[i] }).to be(false)
end
