module Localeapp
  module CLI
    class Command
      def initialize(args = {})
        initialize_config(args)
        @output = args[:output] || $stdout
      end

      # requires the Localeapp configuration
      def initialize_config(args = {})
        Localeapp.configure # load defaults
        load_config_file
        set_command_line_arguments(args)
      end

      def set_command_line_arguments(args = {})
        sanitized_args = {}
        sanitized_args[:api_key] = args[:k] if args[:k]
        [:api_key, :translation_data_directory].each do |k|
          sanitized_args[k] = args[k] if args[k]
        end
        sanitized_args.each do |setting, value|
          Localeapp.configuration.send("#{setting}=", value)
        end
      end

      def load_config_file
        Localeapp.default_config_file_paths.each do |path|
          next unless File.exist? path
          require path
        end
      end
    end
  end
end
