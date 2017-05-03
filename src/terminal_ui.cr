require "./terminal_ui/*"
require "colorize"
require "logger"

class TerminalUI
  VERSION = "0.1.0"

  property logger

  # Returns the instance type of this type.
  #
  # ```
  # Terminal::UI.instance.level = Logger::DEBUG
  # ```
  def self.instance
    @@instance ||= new
  end

  {% for method in [:message, :success, :important, :error, :verbose, :crash, :head] %}
    # Same as `{{method.id}}`.
    def self.{{method.id}}(message)
      instance.{{method.id}}(message)
    end
  {% end %}

  # Creates a new Terminal::UI that will show message to the given io. If io is nil then all message calls will be silently ignored.
  #
  # Set the level only messages at that level of higher will be printed.
  #
  # - DEBUG = 0 Low-level information for developers
  # - INFO = 1  Generic (useful) information about system operation
  # - WARN = 2  A warning
  # - ERROR = 3 A handleable error condition
  # - FATAL = 4 An unhandleable error that results in a program crash
  # - UNKNOWN =
  # More details see `Logger::Severity`.
  #
  # ```
  # Terminal::UI.new
  # Terminal::UI.new(Logger.new(STDOUT))
  # ```
  def initialize(@logger = Logger.new(STDOUT))
    @logger.formatter = default_logger_formatter
  end

  # Print a header = a text in a box
  #   use this if this message is really important
  def header(message)
    text = "---  #{message} ---"
    line = "-" * text.size
    @logger.info(line)
    @logger.info(text)
    @logger.info(line)
  end

  # Level Message: Show a neutral message to the user
  #
  #   By default those messages shown in white/black
  def message(message)
    @logger.info(message.to_s)
  end

  # Level Success: Show that something was successful
  #
  #   By default those messages are shown in green
  def success(message)
    @logger.info(message.to_s.colorize(:green))
  end

  # Level Important: Can be used to show warnings to the user
  #   not necessarily negative, but something the user should
  #   be aware of.
  #
  #   By default those messages are shown in yellow
  def important(message)
    @logger.warn(message.to_s.colorize(:yellow))
  end

  # Level Error: Can be used to show additional error
  #   information before actually raising an exception
  #   or can be used to just show an error from which
  #   fastlane can recover (much magic)
  #
  #   By default those messages are shown in red
  def error(message)
    @logger.error(message.to_s.colorize(:red))
  end

  # Level Verbose: Print out additional information for the
  #   users that are interested. Will only be printed when
  #   FastlaneCore::Globals.verbose? = true
  #
  #   By default those messages are shown in white
  def verbose(message)
    @logger.debug(message.to_s)
  end

  # Pass an exception to this method to exit the program
  #   using the given exception
  # Use this method instead of user_error! if this error is
  # unexpected, e.g. an invalid server response that shouldn't happen
  def crash(message)
    raise Crash.new(message)
  end

  private def default_logger_formatter
    Logger::Formatter.new do |severity, datetime, progname, message, io|
      if ENV.has_key?("TERMINAL_UI_HIDE_TIMESTAMP")
        io << ""
      else
        io << "#{severity} #{datetime.to_s("%Y-%m-%d %H:%M:%S")} "
      end

      io << message
    end
  end

  # raised from crash!
  class Crash < Exception
  end
end

class


TerminalUI.message("sdsdsdsdfsdf")