Then(/^the output should contain only the core repo$/) do
  step %(the output should contain:), "
+------+-----------------------------------------------------------------------------------------------------------+
|                                           Registered spec source repos                                           |
+------+-----------------------------------------------------------------------------------------------------------+
| Name | Url                                                                                                       |
+------+-----------------------------------------------------------------------------------------------------------+
| core | https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs |
+------+-----------------------------------------------------------------------------------------------------------+
".strip
end

Then(/^the UPM source file should exist$/) do
  step %(the file named "#{Upm::SOURCES_PATH}" should exist)
end

Then(/^the UPM source file should contain "([^"]*)"$/) do |content|
  step %(the file named "#{Upm::SOURCES_PATH}" should contain "#{content}")
end

Then(/^the UPM source file should not contain "([^"]*)"$/) do |content|
  step %(the file named "#{Upm::SOURCES_PATH}" should not contain "#{content}")
end

Then(/^I wait for the output to contain the repo named "([^"]*)" with the url "([^"]*)"$/) do |name, url|
  step %(wait for the output to contain), "| #{name} | #{url}"
end
