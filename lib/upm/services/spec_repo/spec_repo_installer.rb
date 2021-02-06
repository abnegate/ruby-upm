module Upm
  # Manages install packages from a spec repo
  class SpecRepoInstaller
    include Upm.injected(
      :shell,
      :progress,
      :spec_repo_syncer
    )

    # @param [String] name      The name of the package to install
    # @param [String] version   The version of the package to install, defaults to the latest version.
    def install(
      name,
      version,
      type = "all",
      repo_name = Upm::CORE_SPEC_REPO_NAME
    )
      spec_repo_syncer.sync(type)

      matches = Dir.glob("#{SPEC_ROOT}/**/*#{name}*").select { |d| Dir.exist?(d) }

      index = 0

      if matches.empty?
        shell.error("No package found with name #{name}")
        exit(-1)
      elsif matches.size > 1
        shell.say("Multiple matches for #{name}")

        matches.each_with_index.map { |match, index| puts Shell.add_date("#{index}: #{match}\n") }

        index = shell.ask(
          "Select the index of the package you want to install:",
          options: (0..matches.size - 1).to_a
        )
        exit(-1)
      end

      match = matches[index]

      if version.nil?
        version = `ls #{match}`.split("\n")[0]
      end

      unless Dir.exist?("#{match}/#{version}")
        shell.error("No package version #{version} found for #{name}")
        exit(-1)
      end

      package = SpecRepoManager.read_package_spec("#{match}/#{version}/#{Upm::SPEC_FILE_PATH}")
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

    def clone_to_project(url, version, path = "upm")
      shell.header("Installing dependency")
      progress.start("Cloning package into project") do
        FileUtils.mkdir_p(path)
        Dir.chdir(path) do
          result = system("git clone #{url} --quiet --branch=#{version} &> /dev/null")
          next Result.failure("Clone failure") unless result
          next Result.success
        end
      end
    end
  end
end
