# frozen_string_literal: true

require "tty-table"

module Upm
  # Manage displaying tabular data
  class TableViewer
    include Upm.injected(
      :shell
    )

    def render(title, *rows)
      return if rows.nil? || rows.empty?

      table = TTY::Table.new(header: rows[0])

      rows.shift
      rows.flatten.each_slice(2) do |name, url|
        unless name.nil? || url.nil? || name.strip.empty? || url.strip.empty?
          table << [name.strip, url.strip]
        end
      end

      shell.say(
        title,
        add_date: false
      )
      puts table.render(:ascii, padding: [0, 1, 0, 1])
    end
  end
end
