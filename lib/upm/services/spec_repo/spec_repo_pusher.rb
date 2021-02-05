module Upm
  # Manages pushing packages to a spec repo
  class SpecRepoPusher
    include Upm.injected(
      :shell,
      :progress,
      :context,
      :context_inflater,
      :spec_repo_syncer,
      :spec_repo_sources_manager
    )

    # @param [String] type
    # @param [String] tag
    def push(
      type,
      tag,
      repo_name
    )
      spec_repo_syncer.sync(type)

      shell.header("Get package context")

      @current_dir = Dir.getwd

      unless Dir.exist?(".git")
        shell.error("No .git found in the current directory!")
        exit(-1)
      end

      unless File.exist?(Upm::SPEC_FILE_PATH)
        shell.error("No spec file found!")
        exit(-1)
      end

      progress.start("Inflating context") do
        context_inflater.fill_context(context, type, tag)
        next Result.success
      end

      shell.header("Publish package")

      unless create_package_tag(context.project.git_release_tag).success
        exit(-1)
      end

      create_release(type, repo_name)

      shell.say("Project #{context.project.name} version #{context.project.git_release_tag} was released successfully!")
    end

    private

    def create_package_tag(version)
      progress.start("Tagging release") do
        if system("git tag #{version} &> /dev/null")
          if system("git push origin #{version} &> /dev/null")
            next Result.success
          else
            next Result.failure("Push error, is your current branch in sync with HEAD?")
          end
        else
          next Result.failure("Tag error, is there already a release with version #{version}?")
        end
      end
    end

    def create_release(type, repo_name)
      spec_root = "#{SPEC_ROOT}/#{type}/#{repo_name}"

      FileUtils.mkdir_p(spec_root)

      Dir.chdir(spec_root) do
        unless File.exist?(context.project.name)
          FileUtils.mkdir_p(context.project.name)
        end

        Dir.chdir(context.project.name) do
          if Dir.exist?(context.project.git_release_tag)
            shell.error("Version already exists!")
            exit(-1)
          end

          FileUtils.mkdir_p(context.project.git_release_tag)
          Dir.chdir(context.project.git_release_tag) do
            copy_spec_package_json
          end
        end

        publish_to_git(repo_name)
      end
    end

    def copy_spec_package_json
      progress.start("Writing spec files") do
        if system("cp #{@current_dir}/#{Upm::SPEC_FILE_PATH} .")
          next Result.success
        else
          next Result.failure("Copy failure, does \"#{Upm::SPEC_FILE_PATH}\" exist?")
        end
      end
    end

    def publish_to_git(repo_name)
      version = context.project.git_release_tag

      result = progress.start("Adding new version") {
        result = system("git add #{context.project.name}/#{version}/#{Upm::SPEC_FILE_PATH} > /dev/null")
        next Result.failure("Spec repo add file error") unless result

        result = system("git commit -m \"[Add] #{context.project.name} #{version}\" &> /dev/null")
        next Result.failure("Spec repo commit error") unless result

        next Result.success
      }

      unless result.success
        shell.error("Publish error")
        exit(-1)
      end

      progress.start("Uploading new version") do
        result = system("git push --set-upstream #{spec_repo_sources_manager[repo_name]} main")
        next Result.failure("Spec repo push error") unless result

        next Result.success
      end
    end
  end
end
