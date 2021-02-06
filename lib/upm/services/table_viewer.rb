# frozen_string_literal: true

require "terminal-table"

module Upm
  # Manage displaying tabular data
  class TableViewer
    include Upm.injected(
      :shell
    )

    def render(title, *rows)
      return if rows.nil? || rows.empty?

      table = Terminal::Table.new(
        title: title,
        headings: rows[0]
      )

      rows.shift
      rows.flatten.each_slice(2) do |name, url|
        unless name.nil? || url.nil? || name.strip.empty? || url.strip.empty?
          table << [name.strip, url.strip]
        end
      end

      puts table
    end
  end
end
