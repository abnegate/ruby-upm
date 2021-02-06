# frozen_string_literal: true

require "tty-spinner"
require "pastel"

module Upm
  # Manages progress UI
  class Progress
    PASTEL = Pastel.new

    def start(task_name, &block)
      spinner = TTY::Spinner.new(
        Shell.add_date("[#{PASTEL.yellow(":spinner")}] #{task_name}"),
        format: "dots",
        hide_cursor: true
      )
      spinner.start

      return spinner if block.nil?

      result = nil
      spinner.run do
        result = yield(spinner)

        unless result.success
          spinner.error("(#{PASTEL.red("failure")}: #{result.message})")
          next
        end

        if result.message.nil?
          spinner.success
        else
          spinner.success("(#{PASTEL.green("success")}: #{result.message})")
        end
      end
      result
    end
  end
end
