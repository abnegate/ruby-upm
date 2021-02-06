# frozen_string_literal: true

require "thor/shell"
require "thor/actions"

module Upm
  # Manages shell interactions
  class ShellTalker < Thor
    include Thor::Shell
    include Thor::Actions

    def self.new_shell
      Color.new
    end
  end

  module Shell
    extend self

    HEADER_PADDING = 8

    @shell = ShellTalker.new_shell

    def cmd(command)
      Shell.new.run(command, verbose: false)
    end

    def header(
      section_name,
      show_step: true,
      add_date: true
    )
      section_name = "Step: #{section_name}" if show_step

      say("-" * (section_name.length + HEADER_PADDING), :green, add_date: add_date)
      say("--- #{section_name} ---", :green, add_date: add_date)
      say("-" * (section_name.length + HEADER_PADDING), :green, add_date: add_date)
    end

    def yes?(message)
      ask(message, options: %w[y n]) == "y"
    end

    def say(
      message,
      color = :blue,
      add_date: true
    )
      message = @shell.set_color(message, color)
      message = add_date(message) if add_date
      @shell.say(message)
    end

    def ask(
      query,
      options: nil,
      default: nil
    )
      query = add_date(@shell.set_color(query, :yellow))

      return ask_simple(query) if options.nil? && default.nil?
      if !options.nil? && !default.nil?
        return ask_default_options(query, options, default)
      end

      ask_options(query, options) unless options.nil?
    end

    def error(message)
      @shell.say(add_date(@shell.set_color("failure: #{message}", :red)))
    end

    def self.add_date(message)
      `date +"[%H:%M:%S]: "`.sub("\n", "") + message
    end

    private

    def ask_simple(query)
      @shell.ask(query)
    end

    def ask_default(query, default)
      @shell.ask(query, default: default)
    end

    def ask_options(query, options)
      @shell.ask(query, limited_to: options)
    end

    def ask_default_options(query, options, default)
      @shell.ask(query, limited_to: options, default: default)
    end
  end
end
