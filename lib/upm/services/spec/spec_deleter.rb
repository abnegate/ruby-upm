module Upm
  # Manages deleting package versions from a spec repo
  class SpecDeleter
    include Upm.injected(
      :context,
      :context_inflator,
      :spec_syncer
    )

    # @param [String] type    The type of package to delete, defaults to reading from context.
    # @param [String] version The version of the package to delete.
    def delete(type, version)
      spec_syncer.sync(type)

      context_inflator.fill_context(context, type)

      unless File.exist?("#{Upm::SPEC_ROOT}/#{type}/#{context.project.name}/#{version}")
        shell.error("Version to delete not found!")
        exit(-1)
      end

      delete_tags

      Dir.chdir(SPEC_ROOT) do
        delete_spec_file
        commit_deletion
        push_deletion
      end

      shell.say("Project #{context.project.name} version #{version} was deleted successfully!")
    end

    private

    def delete_tags
      # Try delete local and remote tags, but continue with spec deletion even if they fail.
      system("git tag -d #{version} &> /dev/null")
      system("git push --delete origin #{version} &> /dev/null")
    end

    def delete_spec_file
      progress.start("Removing version from spec repo") do
        FileUtils.rm_rf("#{context.project.name}/#{version}")
        next Result.success
      end
    end

    def commit_deletion
      progress.start("Comitting removal") do
        result = system("git add #{context.project.name}/#{version} &> /dev/null")
        next Result.failure("Spec repo add file error") unless result

        result = system("git commit -m \"[Delete] #{context.project.name} #{version}\" &> /dev/null")
        next Result.failure("Spec repo commit error") unless result

        next Result.success
      end
    end

    def push_deletion
      progress.start("Finalizing delete") do
        result = system("git push --force &> /dev/null")
        next Result.failure("Spec repo push error") unless result

        next Result.success
      end
    end
  end
end
