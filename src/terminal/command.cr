module Terminal
  class Command
    def self.run(*args, print_command = true, print_command_output = true)
      new.run(*args, print_command: print_command, print_command_output: print_command_output)
    end

    def self.run(*args, print_command = true, print_command_output = true, &block)
      run(*args, print_command: print_command, print_command_output: print_command_output, &block)
    end

    def self.test(*args)
      new.test(*args, false, false)
    end

    def initialize
    end

    def run(*args, print_command = true, print_command_output = true)
      perform_command(*args, print_command: print_command, print_command_output: print_command_output)
    end

    def run(*args, print_command = true, print_command_output = true)
      yield perform_command(*args, print_command: print_command, print_command_output: print_command_output)
    end

    def test(*args)
      shell_command = prepare_command(*args)
      exec_command(shell_command).success?
    end

    private def perform_command(*args, print_command, print_command_output)
      shell_command = prepare_command(*args)
      Terminal.command shell_command if print_command

      result = exec_command(shell_command)
      if result.failure?
        Terminal.shell_error! result.error
      end

      Terminal.command_output result.output if print_command_output
      result
    end

    private def exec_command(shell_command)
      process = Process.new(shell_command, shell: true, output: Process::Redirect::Pipe, error: Process::Redirect::Pipe)
      Result.new(process)
    end

    private def prepare_command(*args)
      shell_command = args.join(" ")
    end

    class Result
      def self.new(process : Process)
        start_time = Time.now
        output = process.output.gets_to_end.strip
        error = process.error.gets_to_end.strip
        status = process.wait
        runtime = Time.now - start_time

        new(status, output, error, runtime)
      end

      getter output
      getter error
      getter runtime

      def initialize(@status : Process::Status, @output : String, @error : String, @runtime : Time::Span)
      end

      delegate success?, to: @status
      delegate normal_exit?, to: @status
      delegate signal_exit?, to: @status

      def failure?
        !success?
      end

      def to_i
        @status.exit_status
      end

      def to_a
        [@output, @error]
      end

      def ==(other)
        return false unless other.is_a?(Terminal::Command::Result)
        to_i == other.to_i && to_a == other.to_a
      end
    end
  end
end