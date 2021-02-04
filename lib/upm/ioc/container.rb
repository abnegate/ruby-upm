# frozen_string_literal: true

module Upm
  class Container
    def self.init
      dependency_container = Dry::Container.new
          .register(PROJECT_MANAGER_SERVICE, -> { ProjectManager.new })
          .register(FILE_MANAGER_SERVICE, -> { FileManager.new })

      #noinspection RubyDynamicConstAssignment
      AutoInject = Dry::AutoInject(dependency_container)
    end
  end
end
