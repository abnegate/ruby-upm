# frozen_string_literal: true

require FileUtils

module Upm
  class FileManager
    def create_directory(root, directory_name)
      Dir.chdir(root) do
        FileUtils.mkdir_p(directory_name)
      end
    end
  end
end
