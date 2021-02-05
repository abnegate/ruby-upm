module Upm
  # Manages install packages from a spec repo
  class SpecRepoInstaller
    include Upm.injected(
      :spec_repo_syncer
    )

    # @param [String] name      The name of the package to install
    # @param [String] version   The version of the package to install, defaults to the latest version.
    def install(
      name,
      version = "latest",
      type = "all",
      repo_name = Upm::CORE_SPEC_REPO_NAME
    )
      spec_repo_syncer.sync(type)

      matches = Dir.glob("#{SPEC_ROOT}/*#{name}*")

      if matches.empty?
        shell.error("No package found with name #{name}")
        exit(-1)
      elsif matches.size > 1
        shell.error("Multiple matches for #{name}")
        exit(-1)
      end

      name = matches[0]

      if version == "latest"
        version = `ls #{SPEC_ROOT}/#{type}/#{name}`.split("\n")[0]
      end

      unless Dir.exist?("#{SPEC_ROOT}/#{name}/#{version}")
        shell.error("No package version #{version} found for #{name}")
        exit(-1)
      end

      package = read_package_spec("#{SPEC_ROOT}/#{name}/#{version}/#{Upm::SPEC_FILE_PATH}")
      url = package["git"]["url"].strip

      if url.nil? || url.empty?
        shell.error("Package has no source url!")
        exit(-1)
      end

      install_package_by_type(
        package["type"],
        url,
        version
      )
    end

    private

    def install_package_by_type(
      package_type,
      package_source_url,
      version
    )
      case package_type
      when "unity"
        clone_to_project(package_source_url, version)
      when "npm"
        clone_to_project(package_source_url, version, "node_modules")
      else
        clone_to_project(package_source_url, version)
      end
    end

    def clone_to_project(url, version, path = ".")
      progress.start("Cloning package into project") do
        result = system("git clone #{url} --branch=#{version} #{path} &> /dev/null")
        next Result.failure("Clone failure") unless result
        next Result.success
      end
    end
  end
end
