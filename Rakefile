# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

require "cucumber"
require "cucumber/rake/task"
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty --format html --out tmp/results.html" # Any valid command line option can go here.
end

task default: %i[spec rubocop]
