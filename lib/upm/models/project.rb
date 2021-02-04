# frozen_string_literal: true

module Upm
  class Project
    attr_accessor :name,
      :root_path,
      :company_name

    def initialize(project_path, name, company_name)
      @root_path = project_path
      @name = name
      @company_name = company_name
    end

    def files_path
      "#{@root_path}/#{@name}"
    end

    def package_name
      "com.#{@company_name}.#{@name}"
    end
  end
end
