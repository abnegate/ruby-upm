# frozen_string_literal: true

require "thor"
require "upm/ioc/container"
require "upm/models/context"
require "upm/models/project"
require "upm/services/project_manager"

module Upm
  class CLI < Thor
    include Upm.inject(:project_manager)

    desc "create <name>", "Create a Unity package with the given name"
    option :company_name, aliases: "-c", required: true, desc: "The company name to set on the package"
    option :path, aliases: "-p", default: ".", desc: "The path to create the package in"
    # @param name [String]
    def create(name)
      project_manager.create(
        options[:path],
        name,
        options[:company_name]
      )
    end
  end

  class Error < StandardError; end
end
