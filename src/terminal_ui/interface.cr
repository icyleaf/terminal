# module TerminalUI
#   abstract class Interface
#     # Creates a new Terminal::UI that will show message to the given io. If io is nil then all message calls will be silently ignored.
#     #
#     # ```
#     # Terminal::UI.new
#     # Terminal::UI.new(Logger.new(STDOUT), Logger::DEBUG)
#     # ```
#     def initialize(@logger = Logger.new(STDOUT))
#       @logger.formatter = default_logger_formatter
#     end

#     # Set the level only messages at that level of higher will be printed.
#     #
#     # - DEBUG = 0 Low-level information for developers
#     # - INFO = 1  Generic (useful) information about system operation
#     # - WARN = 2  A warning
#     # - ERROR = 3 A handleable error condition
#     # - FATAL = 4 An unhandleable error that results in a program crash
#     # - UNKNOWN = 5
#     #
#     # More details see `Logger::Severity`.
#     #
#     def level(level : Logger::Severity)
#       @logger.level = level
#     end

#     # Show the level
#     def level
#       @logger.level
#     end

#     abstract def crash(message)
#     abstract def error(message)
#     abstract def important(message)
#     abstract def success(message)
#     abstract def deprecated(message)
#     abstract def info(message)
#     abstract def verbose(message)

#     private def default_logger_formatter
#       Logger::Formatter.new do |severity, datetime, progname, message, io|
#         if ENV.has_key?("TERMINAL_UI_HIDE_TIMESTAMP")
#           io << ""
#         else
#           io << "#{severity} #{datetime.to_s("%Y-%m-%d %H:%M:%S")} "
#         end

#         io << message
#       end
#     end
#   end
# end