# frozen_string_literal: true

module Upm
  # Manages assets
  class Assets
    PATH = "../../../resources"

    # @return [String]
    def path
      File.join(__dir__, Constants::PATH)
    end

    # @param path [String] The asset to retrieve relative to the assets root
    # @return     [String]
    def get_path(path)
      File.join(Assets.path, path)
    end

    # @param path [String] The asset file to retrieve relative to the assets root
    # @return     [Models::Result]
    def get_file(path)
      text = File.read(get_path(path))
      Result.success(nil, text)
    rescue Errno::ENOENT, IOError => e
      Result.failure("failed: " + e.message)
    end

    # @param path [String] The asset file to retrieve relative to the template root
    # @return     [Models::Result]
    def get_template(path)
      text = File.read(get_path("templates/#{path}"))
      Result.success(nil, text)
    rescue Errno::ENOENT, IOError => e
      Result.failure("failed: " + e.message)
    end
  end
end
