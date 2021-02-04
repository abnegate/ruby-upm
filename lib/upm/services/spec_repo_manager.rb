# frozen_string_literal: true

require "json"

module Upm
  class SpecRepoManager
    include Upm.inject(
      :context,
      :shell,
      :progress
    )

    def sync(type)
      shell.header("Check for updates")

      if has_local_spec_repo?
        pull_spec_repo
      else
        clone_spec_repo
      end
    end

    def release(type, tag)
      sync(type)

      shell.header("Get package context")

      @current_dir = Dir.getwd

      unless Dir.exist?(".git")
        shell.error("No .git found in the current directory!")
        exit(-1)
      end

      unless File.exist?("package.spec.json")
        shell.error("No package.spec.json found in the current directory!")
        exit(-1)
      end

      fill_context(tag)

      unless create_package_tag(context.project.git_release_tag).success
        exit(-1)
      end

      shell.header("Publish package")

      create_release

      shell.say("Version #{context.project.git_release_tag} was released successfully!")
    end

    def delete(type, version)
      sync(type)

      fill_context

      unless File.exist?("#{ENV["HOME"]}/.upm/#{context.project.name}/#{version}")
        shell.error("Version to delete not found!")
        exit(-1)
      end

      Dir.chdir("#{ENV["HOME"]}/.upm") do
        progress.start("Removing version from spec repo") do
          FileUtils.rm_rf("#{context.project.name}/#{version}")
          next Result.success
        end
      end
    end

    def has_local_spec_repo?
      Dir.exist?("#{ENV["HOME"]}/.upm")
    end

    def clone_spec_repo
      progress.start("Cloning spec repo") do
        Dir.chdir do
          if system("git clone --quiet --depth 1 #{Upm::SPEC_REPO_URL} .upm > /dev/null")
            next Result.success
          else
            next Result.failure("Failed to clone spec repo.")
          end
        end
      end
    end

    def pull_spec_repo
      Dir.chdir("#{ENV["HOME"]}/.upm") do
        progress.start("Updating spec repo") do
          if system("git pull origin main --quiet --depth 1 > /dev/null")
            next Result.success
          else
            next Result.failure("Failed to pull spec repo updates.")
          end
        end
      end
    end

    def fill_context(tag = nil)
      package = read_package

      if package["git"]["url"].strip.empty?
        puts "didnt get git url from package"
        package["git"]["url"] = `git ls-remote --get-url origin`
                                    &.gsub("ssh", "https")
                                    &.gsub("git@", "")
                                    &.strip ||
          shell.ask("Please enter the git URL to your project source:")
      end

      package["git"]["tag"] = tag || package["version"]

      write_package(package)

      context.project = Project.new(
        ".",
        File.basename(Dir.getwd),
        package["name"],
        package["description"],
        package["unity"],
        package["unityRelease"],
        package["author"]["name"],
        package["author"]["email"],
        package["author"]["url"],
        package["keywords"],
        package["git"]["url"],
        package["git"]["tag"]
      )

      package
    end

    def create_release
      Dir.chdir("#{ENV["HOME"]}/.upm") do
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
            publish_to_git
          end
        end
      end
    end

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

    def read_package
      result = progress.start("Reading package info") {
        json = File.read("package.spec.json")
        package = JSON.parse(json)
        next Result.success(nil, package)
      }
      result.data
    end

    def write_package(package)
      progress.start("Writing package info") do
        File.write(
          "package.spec.json",
          JSON.pretty_generate(package)
        )
        next Result.success
      end
    end

    def copy_spec_package_json
      progress.start("Writing spec files") do
        if system("cp #{@current_dir}/package.spec.json .")
          next Result.success
        else
          next Result.failure("Copy failure, does \"package.spec.json\" exist in the root of your project?")
        end
      end
    end

    def publish_to_git
      version = context.project.git_release_tag

      progress.start("Adding new version") do
        result = system("git add package.spec.json &> /dev/null")
        next Result.failure("Spec repo add file error") unless result

        result = system("git commit -m \"[Add] #{context.project.name} #{version}\" &> /dev/null")
        next Result.failure("Spec repo commit error") unless result

        next Result.success
      end

      progress.start("Uploading new version") do
        result = system("git push &> /dev/null")
        next Result.failure("Spec repo push error") unless result

        next Result.success
      end
    end
  end
end
