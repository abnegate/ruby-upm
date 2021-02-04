# frozen_string_literal: true

require "thor"
require "upm/ioc/container"

module Upm
  class CLI < Thor
    include Upm::Inject(:project_manager)

    desc "create <name>", "Create a Unity package with the given name"
    option :company_name, aliases: "-c", required: true, desc: "The company name to set on the package"
    option :path, aliases: "-p", default: ".", desc: "The path to create the package in"
    # @param name [String]
    def create(name)
      project_manager.create(
        options[:path],
        options[:company_name],
        name
      )
    end
  end

  class Error < StandardError; end
end
