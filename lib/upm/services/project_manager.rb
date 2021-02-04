# frozen_string_literal: true

require "upm/services/file_manager"
require "upm/services/template_writer"

module Upm
  class ProjectManager
    include Upm.inject(:context)
    include Upm.inject(:file_manager)
    include Upm.inject(:template_writer)

    def create(path, project_name, company_name)
      if path.nil? ||
          project_name.nil? ||
          company_name.nil? ||
          !File.exist?(path)
        exit(-1)
      end

      create_context(path, project_name, company_name)
      create_files
    end

    private_instance_methods

    def create_context(path, project_name, company_name)
      context.project = Project.new(
        path,
        project_name,
        company_name
      )
    end

    def create_files
      file_manager.create_directory(
          context.project.root_path,
          context.project.name
      )

      template_writer.write_templates(
          context.project,
          {
              "project/package.json.erb": "#{context.project.files_path}/package.json",
              "project/README.md.erb": "#{context.project.files_path}/README.md",
              "project/CHANGELOG.md.erb": "#{context.project.files_path}/CHANGELOG.md",
              "project/LICENSE.md.erb": "#{context.project.files_path}/LICENSE.md",
              "project/EditorExample.cs.erb": "#{context.project.files_path}/Editor/EditorExample.cs",
              "project/EditorExampleTest.cs.erb": "#{context.project.files_path}/Tests/Editor/EditorExampleTest.cs",
              "project/Unity.package_name.Editor.asmdef.erb": "#{context.project.files_path}/Editor/Unity.#{context.project.package_name}.Editor.asmdef",
              "project/Unity.package_name.Editor.Tests.asmdef.erb": "#{context.project.files_path}/Tests/Editor/Unity.#{context.project.package_name}.Editor.Tests.asmdef",
              "project/RuntimeExample.cs.erb": "#{context.project.files_path}/Runtime/RuntimeExample.cs",
              "project/RuntimeExampleTest.cs.erb": "#{context.project.files_path}/Tests/Runtime/RuntimeExampleTest.cs",
              "project/Unity.package_name.asmdef.erb": "#{context.project.files_path}/Runtime/Unity.#{context.project.package_name}.asmdef",
              "project/Unity.package_name.Tests.asmdef.erb": "#{context.project.files_path}/Tests/Runtime/Unity.#{context.project.package_name}.Tests.asmdef"
          }
      )
    end
  end
end
