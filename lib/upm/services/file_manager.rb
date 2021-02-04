# frozen_string_literal: true

require "fileutils"

module Upm
  class FileManager
    def create_directory(path, directory_name)
      Dir.chdir(path) do
        FileUtils.mkdir_p(directory_name)
      end
    end
  end
end
