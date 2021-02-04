# frozen_string_literal: true

module Upm
  class Project
    attr_accessor :type,
      :name,
      :root_path,
      :company_name,
      :description,
      :unity_version,
      :unity_release,
      :author_name,
      :author_email,
      :author_url,
      :keywords,
      :git_url,
      :git_release_tag

    def initialize(
      project_type,
      project_path,
      project_name,
      company_name,
      description,
      unity_version,
      unity_release,
      author_name,
      author_email,
      author_url,
      keywords,
      git_url = "",
      git_release_tag = ""
    )
      unless author_name
        author_name = `git config user.name`
        author_name = author_name.strip! || author_name
      end
      unless author_email
        author_email = `git config user.email`
        author_email = author_email.strip! || author_email
      end

      @type = project_type
      @root_path = project_path
      @name = project_name
      @company_name = company_name
      @description = description
      @unity_version = unity_version
      @unity_release = unity_release
      @author_name = author_name || "Name"
      @author_url = author_url
      @author_email = author_email || "email"
      @keywords = keywords
      @git_url = git_url
      @git_release_tag = git_release_tag
    end

    def files_path
      "#{@root_path}/#{@name}"
    end

    def package_name
      "com.#{@company_name}.#{@name}"
    end

    def display_name
      @name.capitalize
    end
  end
end
