# frozen_string_literal: true

require_relative "lib/upm/constants"

Gem::Specification.new do |spec|
  spec.name = "upm"
  spec.version = Upm::VERSION
  spec.authors = ["Jake Barnby"]
  spec.email = ["jakeb994@gmail.com"]

  spec.summary = "Create, manage and deploy Unity packages"
  spec.description = "Easy to use tool that allows creating, managing and deploying Unity packages."
  spec.homepage = "https://github.com/abnegate/ruby-upm"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/abnegate/ruby-upm"
  spec.metadata["changelog_uri"] = "https://github.com/abnegate/ruby-upm/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-auto_inject", "~> 0.7.0"
  spec.add_dependency "dry-container", "~> 0.7.2"
  spec.add_dependency "git", ">= 1.8.1", "< 1.12.0"
  spec.add_dependency "terminal-table", "~> 1.8.0"
  spec.add_dependency "thor", "~> 1.1.0"
  spec.add_dependency "tty-spinner", "~> 0.9.3"
  spec.add_dependency "pastel", "~> 0.8.0"
  spec.add_dependency "parallel", "~> 1.20.1"

  spec.add_development_dependency "aruba", "~> 0.14.14"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.80"
end
