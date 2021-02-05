# frozen_string_literal: true

require "erb"
require "ostruct"
require "upm/services/assets"

module Upm
  class TemplateWriter
    include Upm.injected(:assets)
    include ERB::Util

    def write_templates(binding_object, path_hash)
      path_hash.each do |in_file, out_file|
        write_template(binding_object, in_file, out_file)
      end
    end

    def write_template(
      binding_object,
      template_path,
      out_path,
      append = false
    )
      result = assets.get_template(template_path)
      return result unless result.success

      FileUtils.mkdir_p(File.dirname(out_path))

      erb = ERB.new(result.data, trim_mode: "-")
      output = build_output(erb, binding_object)

      if File.exist?(out_path) && append
        file_text = File.read(out_path)
        if file_text.include?(output) || (file_text == output)
          return Result.new(false, "Already contains required text.")
        end

        output = file_text + output
      end
      File.write(out_path, output)
      result
    end

    def build_output(erb, binding_object)
      if binding_object.is_a?(Hash)
        erb.result(OpenStruct.new(binding_object).instance_eval { binding })
      else
        erb.result(binding_object.instance_eval { binding })
      end
    rescue => e
      puts e
    end
  end
end
