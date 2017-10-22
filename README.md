# terminal-ui

Terminal output styling with intuitive, clean and easy API written by Crystal.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  terminal-ui:
    github: icyleaf/terminal-ui.cr
```

## Usage

```crystal
require "terminal/ui"

Terminal::UI.message "hello world" # => "hello world"
Terminal::UI.success "well done" # => "\e[32mwell done\e[0m"
Terminal::UI.important "Your password is too easy" # => "\e[33mYour password is too easy\e[0m"
Terminal::UI.error "Invaild username or password" # => "\e[31mInvaild username or password\e[0m"
Terminal::UI.command "crystal version" # => "\e[36m$ crystal version\e[0m"
```

### Methods

method | level | description
---|---|---
header | `INFO` | normal default color with table border (Not compatible with emoji)
message | `INFO` | normal default color
success | `INFO` | green color
important | `WARN` | yellow color
error | `ERROR` | red color
verbose | `DEBUG` | normal default color
deprecated | `WARN` | blue with bold color
command | `INFO` | cyan color
crash | Exception | normal default color

### Enable/Disable color

`Terminal::UI.enable_color`/`Terminal::UI.disable_color`

### Verbose mode

Set Enviroment `TERMINAL_UI_SHOW_TIMESTAMP` to `1/true`

```crystal
Terminal::UI.success "Installed successful"
# => "INFO 2017-10-22 12:45:33 \e[32mInstalled successful\e[0m"
```

### Adviances

All the output based on `Logger`, Here support one way to custom the given io and logger formatter.

```crystal
io = IO::Memory.new
Terminal::UI.logger_io(io, Logger::Formatter.new { |severity, datetime, progname, message, io|
  io << "#{datetime.to_s("%H:%M:%S")} "
  io << message
})
```

## Contributing

1. Fork it ( https://github.com/icyleaf/terminal-ui.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [icyleaf](https://github.com/icyleaf) - creator, maintainer
