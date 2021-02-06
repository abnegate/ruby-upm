# frozen_string_literal: true

require "thor"
require "upm/ioc/container"
require "upm/commands/packages"
require "upm/commands/sources"
require "upm/models/context"
require "upm/models/project"
require "upm/services/context_inflator"
require "upm/services/table_viewer"
require "upm/services/project_manager"
require "upm/services/spec/spec_manager"
require "upm/services/spec/spec_syncer"
require "upm/services/spec/spec_pusher"
require "upm/services/spec/spec_deleter"
require "upm/services/spec/spec_installer"
require "upm/services/spec/spec_restorer"
require "upm/services/spec/spec_source_manager"
require "upm/services/spec/spec_package_manager"
require "upm/services/shell"
require "upm/services/progress"
require "upm/constants"

module Upm
  class CLI < Thor
    desc "package SUBCOMMAND ...ARGS", "Manage UPM packages"
    subcommand "package", Packages

    desc "source SUBCOMMAND ...ARGS", "Manage UPM sources"
    subcommand "source", Sources

    map(
      "s" => "source",
      "p" => "package"
    )
  end

  class Error < StandardError; end
end
