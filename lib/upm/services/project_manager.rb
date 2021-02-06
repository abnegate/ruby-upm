# frozen_string_literal: true

require "upm/services/file_manager"
require "upm/services/template_writer"

module Upm
  # Manages a project object
  class ProjectManager
    include Upm.injected(
      :context,
      :shell,
      :progress,
      :file_manager,
      :template_writer
    )

    def create(
      type,
      path,
      project_name,
      company_name,
      description,
      unity_version,
      unity_release,
      author_name,
      author_email,
      author_url,
      keywords,
      git_url
    )
      if path.nil? ||
          project_name.nil? ||
          company_name.nil? ||
          !File.exist?(path)
        exit(-1)
      end

      shell.header("Create package")

      context.project = Project.new(
        type,
        path,
        project_name,
        company_name,
        description,
        unity_version,
        unity_release,
        author_name,
        author_email,
        author_url,
        keywords,
        git_url
      )

      create_files

      shell.say("Project #{context.project.name} was created successfully!")
    end

    def create_files
      progress.start("Creating directories") do
        file_manager.create_directory(
          context.project.root_path,
          context.project.name
        )
        next Result.success
      end

      progress.start("Writing templates") do
        template_writer.write_templates(
          context,
          {
            "project/umpspec.json.erb": "#{context.project.files_path}/upmspec.json",
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
        next Result.success
      end
    end
  end
end
