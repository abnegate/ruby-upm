# frozen_string_literal: true

module Upm
  VERSION = "0.1.0"

  SUPPORTED_TYPES = %w[unity npm ruby rubygem]

  UPM_ROOT = "#{ENV["HOME"]}/.upm"
  SPEC_ROOT = "#{UPM_ROOT}/packages"
  SOURCES_PATH = "#{UPM_ROOT}/sources"
  SPEC_FILE_PATH = "upmspec.json"

  CORE_SPEC_REPO_NAME = "core"
  CORE_SPEC_REPO_URL = "https://unitepackagemanager:f10f3c24f439248345fd448ecf873befe1a7d95b@github.com/unitepackagemanager/specs"
end
