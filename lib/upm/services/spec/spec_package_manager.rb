# frozen_string_literal: true

require "parallel"

module Upm
  class SpecPackageManager
    include Upm.injected(
      :table_viewer
    )

    def list(type, repo_name, is_local)
      type = "all" if type.nil?
      repo_name = "*" if repo_name.nil?

      packages = is_local ?
        get_local_packages :
        get_remote_packages(type, repo_name)

      table_viewer.render(
        "Packages",
        ["Name", "Latest versions"],
        packages.each_slice(2).map { |k, v| [k, v] }
      )
    end

    private

    def get_local_packages
      Dir.chdir("#{Upm::LOCAL_PACKAGES_ROOT}/#{type}") do
        repo_dirs = Dir
          .glob("*")
          .select { |f| Dir.exist?(f) }

        return Parallel.flat_map(repo_dirs) { |repo_dir|
          package_dirs = `ls #{repo_dir}`.split("\n")
          Parallel.flat_map(package_dirs) { |package|
            versions = `ls #{repo_dir}/#{package}`
                .split("\n")
                .take(5)
                .reverse
                .join(", ")
            [package, versions]
          }
        }
      end
    end

    def get_remote_packages(type, repo_name)
      Dir.chdir("#{SPEC_ROOT}/#{type}") do
        repo_dirs = Dir
          .glob(repo_name)
          .select { |f| Dir.exist?(f) }

        return Parallel.flat_map(repo_dirs) { |repo_dir|
          package_dirs = `ls #{repo_dir}`.split("\n")
          Parallel.flat_map(package_dirs) { |package|
            versions = `ls #{repo_dir}/#{package}`.split("\n")
                .take(5).reverse.join(", ")
            [package, versions]
          }
        }
      end
    end
  end
end
