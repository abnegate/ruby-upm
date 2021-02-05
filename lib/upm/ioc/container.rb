# frozen_string_literal: true

require "dry-container"
require "dry-auto_inject"

module Upm
  container = Dry::Container.new
  container.register(:context, -> { Context.new })
  container.register(:context_inflater, -> { ContextInflater.new })
  container.register(:project_manager, -> { ProjectManager.new })
  container.register(:file_manager, -> { FileManager.new })
  container.register(:spec_repo_manager, -> { SpecRepoManager.new })
  container.register(:spec_repo_syncer, -> { SpecRepoSyncer.new })
  container.register(:spec_repo_pusher, -> { SpecRepoPusher.new })
  container.register(:spec_repo_deleter, -> { SpecRepoDeleter.new })
  container.register(:spec_repo_installer, -> { SpecRepoInstaller.new })
  container.register(:spec_repo_restorer, -> { SpecRepoRestorer.new })
  container.register(:spec_repo_sources_manager, -> { SpecRepoSourcesManager.new })
  container.register(:template_writer, -> { TemplateWriter.new })
  container.register(:assets, -> { Assets.new })
  container.register(:shell, -> { Shell })
  container.register(:progress, -> { Progress.new })

  Dry::AutoInject = Dry::AutoInject(container)

  def self.injected(*keys)
    Dry::AutoInject[*keys]
  end
end
