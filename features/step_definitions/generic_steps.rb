When(/^I wait for interactive (?:output|stdout) to contain "([^"]*)"$/) do |expected|
  Timeout.timeout(aruba.config.exit_timeout) do
    loop do
      begin
        expect(last_command_started).to have_interactive_output an_output_string_including(expected)
      rescue RSpec::Expectations::ExpectationNotMetError
        sleep 0.01
        retry
      end

      break
    end
  end
end

Then(/^the file named "([^"]*)" should contain all of:$/) do |file_name, expectations|
  return if expectations.nil?

  expectations = expectations.raw.flatten.map(&:strip)
  expectations.each do |expected|
    step(%(the file named "#{file_name}" should contain:), expected)
  end
end
