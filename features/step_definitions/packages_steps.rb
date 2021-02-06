Then(/^the output should contain the packages table$/) do
  step %(the output should contain:), "Packages"
  step %(the output should contain:), "Name"
  step %(the output should contain:), "Latest versions"
  step %(the output should contain:), "com.jakebarnby.upm"
end
