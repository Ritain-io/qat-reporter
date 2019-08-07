And(/^I embed a text evidence$/) do
  File.open("evidence.txt", 'w') {|f| f.write("TEST EVIDENCE") }
  embed 'evidence.txt', 'text/plain', 'Text evidence'
end
