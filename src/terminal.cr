require "./terminal/*"

module Terminal
  class Error < Exception; end
  class ShellError < Error; end
  class UserError < Error; end
  class Crash < Error; end

  {% for method in [:message, :success, :important, :error, :verbose, :header, :deprecated, :command, :command_output, :crash!, :user_error!, :shell_error!] %}
    # Same as Terminal::UI.new.`{{method.id}}(message)`.
    #
    # ```
    # Terminal.{{method.id}}("{{method.id}}")
    # ```
    def self.{{method.id}}(message)
      ui.{{method.id}}(message)
    end
  {% end %}

  {% for method in [:disable_color, :enable_color] %}
    # Terminal.`{{method.id}}`
    def self.{{method.id}}
      ui.{{method.id}}
    end
  {% end %}

  def self.sh(*args, print_command = true, print_command_output = true)
    command.run(*args, print_command: print_command, print_command_output: print_command_output)
  end

  def self.test(*args)
    command.test(*args)
  end

  def self.ui_logger(io, formatter = ui.default_logger_formatter)
    ui.logger = Logger.new(io)
    ui.logger.level = Logger::DEBUG
    ui.logger.formatter = formatter
  end

  private def self.ui
    @@ui ||= UI.new
  end

  private def self.command
    @@command ||= Command.new
  end
end
