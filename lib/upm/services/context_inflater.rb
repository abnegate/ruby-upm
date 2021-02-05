module Upm
  class ContextInflater
    def fill_context(context, type, tag = nil)
      package = SpecRepoManager.read_package_spec

      if package["git"]["url"].strip.empty?
        package["git"]["url"] = `git ls-remote --get-url origin`
                                    &.gsub("ssh", "https")
                                    &.gsub("git@", "")
                                    &.strip ||
          shell.ask("Please enter the git URL to your project source:")
      end

      package["git"]["tag"] = tag || package["version"]

      SpecRepoManager.write_package_spec(package)

      context.project = Project.new(
        type,
        ".",
        package["name"],
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
  end
end
