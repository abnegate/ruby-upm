require "aruba/cucumber"

Aruba.configure do |config|
  config.exit_timeout = 15
  config.io_wait_timeout = 2
  config.activate_announcer_on_command_failure = [:output]
  config.keep_ansi = true
end

RSpec::Matchers.define :have_interactive_output do |expected|
  match do |actual|
    @old_actual = actual

    raise "Expected #{@old_actual} to respond to #output" unless @old_actual.respond_to? :output

    @actual = sanitize_text(actual.output)

    values_match?(expected, @actual)
  end

  diffable

  description { "have interactive output: #{description_of expected}" }
end

if RSpec::Expectations::Version::STRING >= "3.0"
  RSpec::Matchers.alias_matcher :a_command_having_output, :have_interactive_output
end
