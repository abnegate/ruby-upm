# frozen_string_literal: true

module Upm
  # Manages syncing updates to and from a spec repo
  class SpecSyncer
    include Upm.injected(
      :shell,
      :progress,
      :spec_source_manager
    )

    # @param [String] type The type of packages to sync, or nil if no filtering is desired.
    def sync(type)
      shell.header("Check for updates")

      FileUtils.mkdir_p(Upm::UPM_ROOT)

      spec_source_manager[Upm::CORE_SPEC_REPO_NAME] = Upm::CORE_SPEC_REPO_URL

      progress.start("Syncing spec source repos") do
        spec_source_manager.each_source_parallel do |spec_repo_name, spec_repo_url|
          spec_root = "#{SPEC_ROOT}/#{type}/#{spec_repo_name}"

          # FIXME: This will duplicate packages in "all" if they are also in a specific type set?
          if SpecManager.has_local_spec_repo?(type, spec_repo_name)
            pull_spec_repo(spec_repo_name, spec_root)
          else
            clone_spec_repo(spec_repo_name, spec_repo_url, spec_root)
          end
        end
        next Result.success
      end

      shell.say("Synced successfully!")
    end

    private

    def clone_spec_repo(
      repo_name,
      repo_url,
      spec_root
    )
      FileUtils.mkdir_p(spec_root)
      Dir.chdir(spec_root) do
        system("git init . > /dev/null")
        system("git checkout -b main --quiet > /dev/null")
        system("git remote add origin #{repo_url} > /dev/null")
        if system("git pull --quiet --depth 1 origin main > /dev/null")
          next Result.success
        else
          next Result.failure("Failed to clone spec repo #{repo_name}.")
        end
      end
    end

    def pull_spec_repo(repo_name, spec_root)
      FileUtils.mkdir_p(spec_root)
      Dir.chdir(spec_root) do
        if system("git pull origin main --quiet --depth 1 > /dev/null")
          next Result.success
        else
          next Result.failure("Failed to pull spec repo #{repo_name} updates.")
        end
      end
    end
  end
end
