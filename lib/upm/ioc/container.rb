# frozen_string_literal: true

require "dry-container"
require "dry-auto_inject"

module Upm
  container = Dry::Container.new
  container.register(:context, -> { Context.new })
  container.register(:project_manager, -> { ProjectManager.new })
  container.register(:file_manager, -> { FileManager.new })
  container.register(:spec_repo_manager, -> { SpecRepoManager.new })
  container.register(:template_writer, -> { TemplateWriter.new })
  container.register(:assets, -> { Assets.new })
  container.register(:shell, -> { Shell })
  container.register(:progress, -> { Progress.new })

  Dry::AutoInject = Dry::AutoInject(container)

  def self.inject(*keys)
    Dry::AutoInject[*keys]
  end
end
