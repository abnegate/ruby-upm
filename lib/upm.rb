# frozen_string_literal: true

require "thor"
require "upm/ioc/container"
require "upm/models/context"
require "upm/models/project"
require "upm/services/project_manager"
require "upm/services/spec_repo_manager"
require "upm/services/shell"
require "upm/services/progress"

module Upm
  class CLI < Thor
    include Upm.inject(
      :project_manager,
      :spec_repo_manager
    )

    desc "create <name>", "Create a Unity package with the given name"
    option :company_name, aliases: "-c", required: true, desc: "The company name to set on the package"
    option :path, aliases: "-p", default: ".", desc: "The path to create the package in"
    option :description, aliases: "-d", default: "Description", desc: "A description of the package"
    option :unity_version, aliases: "-v", default: "2019.1", desc: "The unity version to build the package against"
    option :unity_release, aliases: "-r", default: "0b5", desc: "The unity release to build the package against"
    option :author_name, aliases: "-n", default: nil, desc: "The package author's name"
    option :author_email, aliases: "-e", default: nil, desc: "The package author's email"
    option :author_url, aliases: "-u", default: "", desc: "Author URL"
    option :keywords, aliases: "-k", default: [], type: :array, desc: "A set of keywords that describe the package"
    option :git_url, aliases: "-g", default: "", desc: "URL to the git project"
    # @param name [String]
    def create(name)
      project_manager.create(
        options[:path],
        name,
        options[:company_name],
        options[:description],
        options[:unity_version],
        options[:unity_release],
        options[:author_name],
        options[:author_email],
        options[:author_url],
        options[:keywords],
        options[:git_url]
      )
    end

    desc "sync", "Sync with repo"
    def sync
      spec_repo_manager.sync
    end

    desc "release", "Publish the current package"
    def release
      spec_repo_manager.release
    end

    desc "delete", "Publish the current package"
    option :git_url, aliases: "-g", required: true, desc: "URL to the git project"
    def delete(version)
      spec_repo_manager.delete(
        version
      )
    end
  end

  class Error < StandardError; end
end
