module Upm
  class Sources < Thor
    include Upm.injected(
      :spec_manager,
      :spec_source_manager
    )

    desc "sync", "Sync with all spec repos"
    option :type, aliases: "-t", enum: Upm::SUPPORTED_TYPES, desc: "The type of package to sync, or all if not defined"
    def sync
      spec_manager.sync(options[:type])
    end

    desc "list", "List all spec repos"
    def list
      spec_manager.sync("all")
      spec_manager.list_sources
    end

    desc "add", "Add a spec repo"
    option :name, aliases: "-n", desc: "The spec repo name to add"
    option :url, aliases: "-u", desc: "The spec repo url to add"
    def add
      spec_manager.add_source(options[:name], options[:url])
      spec_manager.sync("all")
    end

    desc "remove", "Remove a spec repo"
    def remove(name)
      spec_manager.remove_source(name)
      spec_manager.sync("all")
    end

    map(
      "s" => "sync",
      "l" => "list",
      "a" => "add",
      "r" => "remove"
    )
  end
end
