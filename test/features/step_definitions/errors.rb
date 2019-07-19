Then /^an? "([^"]*)" exception is raised$/ do |klass|
  refute_nil @error, "Expected a #{klass} exception to have occured, but none was found"
  log.debug @error
  assert_equal klass, @error.class.to_s
end

Then /^no exception is raised$/ do
  assert_nil @error, "Expected no exception to have occured, but one was found"
end

And(/^the exception message should be "([^"]*)"$/) do |message|
  assert_equal(message, @error.message)
end