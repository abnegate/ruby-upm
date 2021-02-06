# frozen_string_literal: true

require "json"

module Upm
  # Manages a local UPM environment
  class SpecManager
    include Upm.injected(
      :context,
      :shell,
      :progress,
      :spec_syncer,
      :spec_pusher,
      :spec_deleter,
      :spec_installer,
      :spec_restorer,
      :spec_source_manager
    )

    def list_sources
      spec_source_manager.list
    end

    def add_source(repo_name, repo_url)
      spec_source_manager[repo_name] = repo_url
    end

    def remove_source(repo_name)
      spec_source_manager[repo_name] = nil
    end

    def sync(type)
      spec_syncer.sync(type)
    end

    def push(type, tag, repo_name)
      spec_pusher.push(type, tag, repo_name)
    end

    def delete(type, version)
      spec_deleter.delete(type, version)
    end

    def install(name, version)
      spec_installer.install(name, version)
    end

    def restore_packages
      spec_restorer.restore_packages
    end

    def self.has_local_spec_repo?(type, repo_name)
      type = "all" if type.nil?

      Dir.exist?("#{SPEC_ROOT}/#{type}/#{repo_name}")
    end

    def self.read_package_spec(path = Upm::SPEC_FILE_PATH)
      json = File.read(path)
      JSON.parse(json)
    end

    def self.write_package_spec(package)
      File.write(
        Upm::SPEC_FILE_PATH,
        JSON.pretty_generate(package)
      )
    end
  end
end
