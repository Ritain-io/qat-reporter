Given(/^some pre\-settings$/) do
  assert true
end

Given(/^I have a condition$/) do
  assert true
end

When(/^I do an action (.*)$/) do |action|
  case action
    when 'action1'
      assert true
    when 'action2'
      assert true
    else
      assert false
  end
end

Then(/^I have a result (.*)$/) do |result|
  case result
    when 'passed'
      assert true
    else
      assert false
  end
end
