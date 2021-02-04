# frozen_string_literal: true

module Upm
  class CLI < Thor
    include AutoInject[PROJECT_MANAGER_SERVICE]

    desc "create <name>", "Create a Unity package with the given name"
    option :path, aliases: "-p", default: ".", desc: "The path to create the package in"
    # @param name [String]
    def create(name)
      project_manager.create(name, options[:path])
    end
  end

  class Error < StandardError; end
  # Your code goes here...
end