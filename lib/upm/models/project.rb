# frozen_string_literal: true

module Upm
  class Project
    attr_accessor :name,
      :root_path,
      :company_name

    def initialize(name, project_path, company_name)
      @name = name
      @root_path = project_path
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
