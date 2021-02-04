# frozen_string_literal: true

require "dry-container"
require "dry-auto_inject"

module Upm
  container = Dry::Container.new
  container.register(:context, -> { Context.new })
  container.register(:project_manager, -> { ProjectManager.new })
  container.register(:file_manager, -> { FileManager.new })
  container.register(:template_writer, -> { TemplateWriter.new })
  container.register(:assets, -> { Assets.new })

  Dry::AutoInject = Dry::AutoInject(container)

  def self.Inject(*keys)
    Dry::AutoInject[*keys]
  end
end
