module Upm
  class Sources < Thor
    include Upm.injected(
      :spec_repo_manager,
      :spec_repo_sources_manager
    )

    desc "sync", "Sync with repo"
    option :type, aliases: "-t", enum: Upm::SUPPORTED_TYPES, default: nil, desc: "The type of package to sync, or all if not defined"
    def sync
      spec_repo_manager.sync(
        options[:type]
      )
    end

    desc "list", "List all spec repos"
    def list
      spec_repo_manager.list_sources
    end

    desc "add", "Add a spec repo"
    option :url, aliases: "-u", default: Upm::CORE_SPEC_REPO_URL, desc: "The repo url to sync"
    option :name, aliases: "-n", default: Upm::CORE_SPEC_REPO_NAME, desc: "The repo name to sync"
    def add
      spec_repo_manager.add_source(
        options[:name],
        options[:url]
      )
      spec_repo_manager.sync("all")
    end

    desc "remove", "Remove a spec repo"
    def remove(name)
      spec_repo_manager.remove_source(
        name
      )
      spec_repo_manager.sync("all")
    end

    map(
      "s" => "sync",
      "l" => "list",
      "a" => "add",
      "r" => "remove"
    )
  end
end
