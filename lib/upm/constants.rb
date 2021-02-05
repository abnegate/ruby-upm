# frozen_string_literal: true

module Upm
  VERSION = "0.1.0"

  SUPPORTED_TYPES = [
    "unity",
    "npm",
    "ruby",
    "rubygem"
  ]

  UPM_ROOT = "#{ENV["HOME"]}/.upm"
  SPEC_ROOT = "#{UPM_ROOT}/packages"
  SOURCES_PATH = "#{UPM_ROOT}/sources"
  SPEC_FILE_PATH = "upmspec.json"

  CORE_SPEC_REPO_NAME = "core"
  CORE_SPEC_REPO_URL = "https://unitepackagemanager:b6a579fab8681e052d489ad0a532c00ea5387875@github.com/unitepackagemanager/specs"
end
