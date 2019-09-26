require "colorize"
require "logger"
require "./constants"

class Terminal::UI
  property logger

  # Creates a new TerminalUI that will show message to the given io. If io is nil then all message calls will be silently ignored.
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
  # logger_io = STDOUT
  # logger_formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
  #   io << "#{datetime.to_s("%H:%M:%S")} "
  #   io << message
  # end
  #
  # TerminalUI.new(logger_io, logger_formatter)
  # ```
  def initialize(logger_io = STDOUT, logger_formatter = default_logger_formatter)
    @logger = Logger.new(logger_io, Logger::DEBUG, logger_formatter)
  end

  # Print a header a text in a box
  #   use this if this message is really important
  def header(message)
    message = " #{message.strip} "
    message_width = display_width(message)
    header_line = "+" + "-" * message_width + "+"
    text = "|#{message}|"
    footbar_line = "+" + "-" * message_width + "+"

    @logger.info(header_line)
    @logger.info(text)
    @logger.info(footbar_line)
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
    @logger.info(message.to_s.colorize.green)
  end

  # Level Important: Can be used to show warnings to the user
  #   not necessarily negative, but something the user should
  #   be aware of.
  #
  #   By default those messages are shown in yellow
  def important(message)
    @logger.warn(message.to_s.colorize.yellow)
  end

  # Level Error: Can be used to show additional error
  #   information before actually raising an exception
  #   or can be used to just show an error from which
  #   fastlane can recover (much magic)
  #
  #   By default those messages are shown in red
  def error(message)
    @logger.error(message.to_s.colorize.red)
  end

  # Level Verbose: Print out additional information for the
  #   users that are interested. Will only be printed when
  #   FastlaneCore::Globals.verbose? = true
  #
  #   By default those messages are shown in white
  def verbose(message)
    @logger.debug(message.to_s)
  end

  # Level Deprecated: Show that a particular function is deprecated
  #
  #   By default those messages shown in strong blue
  def deprecated(message)
    @logger.warn(message.to_s.colorize.blue.bold)
  end

  # Level Command: Print out a terminal command that is being
  def command(message)
    @logger.info("$ #{message}".colorize.cyan)
  end

  # Level Command Output: Print the output of a command with
  def command_output(message)
    message.split("\n").each do |line|
      prefix = line.includes?("▸") ? "" : "▸ "
      @logger.info("#{prefix}#{line.colorize.magenta}")
    end
  end

  # Pass an exception to this method to exit the program using the given exception
  # Use this method instead of user_error! if this error is
  # unexpected, e.g. an invalid server response that shouldn't happen
  def crash!(message)
    raise Crash.new(message.to_s)
  end

  # Use this method to exit the program because of an user error
  def user_error!(message)
    raise UserError.new(message)
  end

  # Use this method to exit the program because of a shell command failure –
  # the command returned a non-zero response.
  #
  # This does not specify the nature of the error.
  # The error might be from a programming error, a user error.
  # Because of this, when these errors occur, it means that the caller of
  # the shell command did not adequate error handling and the caller error
  # handling should be improved.
  def shell_error!(message)
    raise ShellError.new(message)
  end

  # Enable text colorful in STDOUT TTY
  def enable_color
    Colorize.enabled = true
  end

  # Diable text colorful in STDOUT TTY
  def disable_color
    Colorize.enabled = false
  end

  def default_logger_formatter
    Logger::Formatter.new do |severity, datetime, progname, message, io|
      if ENV.has_key?("TERMINAL_UI_SHOW_TIMESTAMP")
        io << "#{severity} #{datetime.to_s("%F %T")} "
      else
        io << ""
      end

      io << message
    end
  end

  # Return display width of a unicode string(special CJK language)
  private def display_width(text, ambiguous = 1, overwrite = {} of Int32 => Int32)
    res = text.codepoints.reduce(0) do |total_width, codepoint|
      index_or_value = UNICODE_INDEX

      codepoint_depth_offset = codepoint
      UNICODE_DEPTHS.each do |depth|
        index_or_value = index_or_value[codepoint_depth_offset // depth]
        codepoint_depth_offset = codepoint_depth_offset % depth
        break unless index_or_value.is_a?(Array)
      end

      width = index_or_value.is_a?(Array) ? index_or_value[codepoint_depth_offset] : index_or_value
      width = ambiguous if width == :A

      width_offset = width.is_a?(Int32) ? width : 1
      width_offset += overwrite[codepoint] if overwrite[codepoint]?

      total_width + width_offset
    end

    res = res < 0 ? 0 : res
  end
end
