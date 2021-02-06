# frozen_string_literal: true

require "fileutils"
require "parallel"

module Upm
  # Manages spec repo sources
  class SpecSourceManager
    include Upm.injected(
      :table_viewer,
      :progress,
      :shell
    )

    def [](name)
      load if @sources.nil?

      @sources[name]
    end

    def []=(name, url)
      load if @sources.nil?

      if url.nil?
        @sources.delete(name)
      else
        @sources[name] = url
      end
      write_sources
    end

    def each_source(&block)
      return if block.nil?

      @sources.each do |name, url|
        yield(name, url) unless name.nil? || url.nil?
      end
    end

    def each_source_parallel(&block)
      return if block.nil?

      Parallel.each(@sources) do |source|
        yield(source[0], source[1]) unless source[0].nil? || source[1].nil?
      end
    end

    def list
      load if @sources.nil?

      table_viewer.render(
        "Registered spec source repos",
        ["Name", "Url"],
        @sources.flat_map { |name, url| [name, url] }
      )
    end

    private

    def load
      @sources = {}

      sources = begin
                  File.read(Upm::SOURCES_PATH)
                rescue Errno::ENOENT
                  "#{Upm::CORE_SPEC_REPO_NAME}=#{Upm::CORE_SPEC_REPO_URL}"
                end

      sources.each_line do |line|
        parts = line.split("=")
        name = parts[0]
        url = parts[1]

        @sources[name] = url
      end
    end

    def write_sources
      sources_text = ""
      each_source do |name, url|
        sources_text += "#{name}=#{url}\n"
      end

      FileUtils.mkdir_p(File.dirname(Upm::SOURCES_PATH))
      File.write(Upm::SOURCES_PATH, sources_text)
    end
  end
end
