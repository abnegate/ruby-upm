module Upm
  class Packages < Thor
    include Upm.injected(
      :project_manager,
      :spec_manager
    )

    desc "list", "List all packages in the given or all"
    option :type, aliases: "-t", enum: Upm::SUPPORTED_TYPES, desc: "The type of package to create"
    option :repo_name, aliases: "-n", default: Upm::CORE_SPEC_REPO_NAME, desc: "The repo name to push to, defaults to core"
    option :local, aliases: "-l", default: false, desc: "List local packages instead of remote"
    def list
      spec_manager.list_packages(
        options[:type],
        options[:repo_name],
        options[:local]
      )
    end

    desc "create <name>", "Create a Unity package with the given name"
    option :type, aliases: "-t", enum: Upm::SUPPORTED_TYPES, default: "unity", desc: "The type of package to create"
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
    # @param [String] name  The name of the project
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

    desc "push", "Publish the current package"
    option :type, aliases: "-t", enum: Upm::SUPPORTED_TYPES, default: "unity", desc: "The type of package to release"
    option :tag, aliases: "-t", default: nil, desc: "The git tag to match this release, defaults to the current version"
    option :repo_name, aliases: "-n", default: Upm::CORE_SPEC_REPO_NAME, desc: "The repo name to push to, defaults to core"
    def push
      spec_manager.push(
        options[:type],
        options[:tag],
        options[:repo_name]
      )
    end

    # Not sure if delete should be allowed
    #
    # desc "delete", "Delete the current package"
    # option :type, aliases: "-t", enum: ["unity", "npm"], default: "unity", desc: "The type of package to delete"
    # def delete(version)
    #   spec_manager.delete(options[:type], version)
    # end

    desc "install", "Install a package in the current directory"
    option :version, aliases: "-v", desc: "The version to install"
    def install(name)
      spec_manager.install(
        name,
        options[:version]
      )
    end

    desc "restore", "Restore packages defined in the current project"
    def restore
      spec_manager.restore_packages
    end

    map(
      "l" => "list",
      "c" => "create",
      "p" => "push",
      "d" => "delete",
      "i" => "install",
      "r" => "restore"
    )
  end
end
