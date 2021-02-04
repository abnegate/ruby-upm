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
    option :type, aliases: "-t", enum: ["unity", "npm"], default: "unity", desc: "The type of package to create"
    option :company_name, aliases: "-c", required: true, desc: "The company name to set on the package"
    option :path, aliases: "-p", default: ".", desc: "The path to create the package in"
    option :description, aliases: "-d", default: "New package", desc: "A description of the package"
    option :author_name, aliases: "-n", default: nil, desc: "The package author's name"
    option :author_email, aliases: "-e", default: nil, desc: "The package author's email"
    option :author_url, aliases: "-u", default: "", desc: "Author URL"
    option :keywords, aliases: "-k", default: [], type: :array, desc: "A set of keywords that describe the package"
    option :git_url, aliases: "-g", default: "", desc: "URL to the git project"
    # Unity specific
    option :unity_version, aliases: "-v", default: "2019.1", desc: "The unity version to build the package against"
    option :unity_release, aliases: "-r", default: "0b5", desc: "The unity release to build the package against"
    # @param name [String]
    def create(name)
      project_manager.create(
        options[:type],
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
    option :type, aliases: "-t", enum: ["all", "unity", "npm"], default: "all", desc: "The type of package to sync, or all if not defined"
    def sync
      spec_repo_manager.sync(options[:type])
    end

    desc "release", "Publish the current package"
    option :type, aliases: "-t", enum: ["unity", "npm"], default: "unity", desc: "The type of package to release"
    option :tag, aliases: "-t", default: nil, desc: "The git tag to match this release"
    def release
      spec_repo_manager.release(
          options[:type],
          options[:tag]
      )
    end

    # Not sure if delete should be allowed as it's so public
    #
    # desc "delete", "Delete the current package"
    # option :type, aliases: "-t", enum: ["unity", "npm"], default: "unity", desc: "The type of package to delete"
    # def delete(version)
    #   spec_repo_manager.delete(options[:type], version)
    # end

    desc "install", "Install a package in the current directory"
    option :version, aliases: "-v", default: "latest", desc: "The version to install"
    def install(name)
      spec_repo_manager.install(
        name,
        options[:version]
      )
    end
  end

  class Error < StandardError; end
end
