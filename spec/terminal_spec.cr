require "./spec_helper"

describe Terminal do
  it "should output normal message" do
    IO.pipe do |r, w|
      Terminal.ui_logger(w)
      Terminal.message("normal:hello world")
      r.gets.should eq "normal:hello world"
    end
  end

  it "should output success message" do
    IO.pipe do |r, w|
      Terminal.ui_logger(w)
      Terminal.success("success:message")
      r.gets.should eq "\e[32msuccess:message\e[0m"
    end
  end

  it "should output error message" do
    IO.pipe do |r, w|
      Terminal.ui_logger(w)
      Terminal.error("error:message")
      r.gets.should eq "\e[31merror:message\e[0m"
    end
  end

  it "should output important message" do
    IO.pipe do |r, w|
      Terminal.ui_logger(w)
      Terminal.important("important:message")
      r.gets.should eq "\e[33mimportant:message\e[0m"
    end
  end

  it "should output verbose message" do
    IO.pipe do |r, w|
      Terminal.ui_logger(w)
      Terminal.verbose "verbose:message"
      r.gets.should eq "verbose:message"
    end
  end

  it "should output deprecated message" do
    IO.pipe do |r, w|
      Terminal.ui_logger(w)
      Terminal.deprecated "deprecated:message"
      r.gets.should eq "\e[34;1mdeprecated:message\e[0m"
    end
  end

  it "should output header message" do
    IO.pipe do |r, w|
      Terminal.ui_logger(w)
      time_field = Time.now.to_s("%F %T")

      title = "Install"
      Terminal.header title

      r.gets.should eq "+---------+"
      r.gets.should eq "| Install |"
      r.gets.should eq "+---------+"
    end
  end

  it "should output command line" do
    IO.pipe do |r, w|
      Terminal.ui_logger(w)
      time_field = Time.now.to_s("%F %T")

      Terminal.command "crystal version"
      r.gets.should eq "\e[36m$ crystal version\e[0m"
    end
  end

  it "should throws an exception with crash message" do
    expect_raises Terminal::Crash do
      Terminal.crash! "crash:it"
    end
  end

  it "should throws an exception with shell error message" do
    expect_raises Terminal::ShellError do
      Terminal.shell_error! "crash:it"
    end
  end

  it "should enable/disable color" do
    IO.pipe do |r, w|
      Terminal.ui_logger(w)
      Terminal.disable_color
      Terminal.success "success:message"
      r.gets.should eq "success:message"

      Terminal.enable_color
      Terminal.success "success:message"
      r.gets.should eq "\e[32msuccess:message\e[0m"
    end
  end

  it "could show timestamp" do
    ENV["TERMINAL_UI_SHOW_TIMESTAMP"] = "1"
    IO.pipe do |r, w|
      time_field = Time.now.to_s("%F %T")

      Terminal.ui_logger(w)
      Terminal.disable_color
      Terminal.success "success:message"
      r.gets.should eq "INFO #{time_field} success:message"

      Terminal.enable_color

      Terminal.message("normal:hello world")
      r.gets.should eq "INFO #{time_field} normal:hello world"

      Terminal.success "success:message"
      r.gets.should eq "INFO #{time_field} \e[32msuccess:message\e[0m"

      Terminal.error("error:message")
      r.gets.should eq "ERROR #{time_field} \e[31merror:message\e[0m"

      Terminal.important("important:message")
      r.gets.should eq "WARN #{time_field} \e[33mimportant:message\e[0m"

      Terminal.command "crystal version"
      r.gets.should eq "INFO #{time_field} \e[36m$ crystal version\e[0m"

      Terminal.deprecated "deprecated:message"
      r.gets.should eq "WARN #{time_field} \e[34;1mdeprecated:message\e[0m"

      Terminal.verbose "verbose:message"
      r.gets.should eq "DEBUG #{time_field} verbose:message"
    end
  end

  it "could set custom output formatter" do
    ENV["TERMINAL_UI_SHOW_TIMESTAMP"] = "1"
    IO.pipe do |r, w|
      time_field = Time.now.to_s("%F")
      Terminal.ui_logger(w, Logger::Formatter.new { |severity, datetime, progname, message, io|
        io << "#{datetime.to_s("%F")} "
        io << message
      })

      Terminal.message("normal:hello world")
      r.gets.should eq "#{time_field} normal:hello world"
    end
  end
end
