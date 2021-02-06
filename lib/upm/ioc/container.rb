# frozen_string_literal: true

require "dry-container"
require "dry-auto_inject"

module Upm
  container = Dry::Container.new
  container.register(:context, -> { Context.new })
  container.register(:context_inflator, -> { ContextInflator.new })
  container.register(:table_viewer, -> { TableViewer.new })
  container.register(:project_manager, -> { ProjectManager.new })
  container.register(:file_manager, -> { FileManager.new })
  container.register(:spec_manager, -> { SpecManager.new })
  container.register(:spec_syncer, -> { SpecSyncer.new })
  container.register(:spec_pusher, -> { SpecPusher.new })
  container.register(:spec_deleter, -> { SpecDeleter.new })
  container.register(:spec_installer, -> { SpecInstaller.new })
  container.register(:spec_restorer, -> { SpecRestorer.new })
  container.register(:spec_source_manager, -> { SpecSourceManager.new })
  container.register(:template_writer, -> { TemplateWriter.new })
  container.register(:assets, -> { Assets.new })
  container.register(:shell, -> { Shell })
  container.register(:progress, -> { Progress.new })

  Dry::AutoInject = Dry::AutoInject(container)

  def self.injected(*keys)
    Dry::AutoInject[*keys]
  end
end
