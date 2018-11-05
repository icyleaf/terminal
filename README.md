# 💎 terminal-ui

[![Language](https://img.shields.io/badge/language-crystal-776791.svg)](https://github.com/crystal-lang/crystal)
[![Tag](https://img.shields.io/github/tag/icyleaf/terminal-ui.cr.svg)](https://github.com/icyleaf/terminal-ui.cr/blob/master/CHANGELOG.md)
[![Build Status](https://img.shields.io/circleci/project/github/icyleaf/terminal-ui.cr/master.svg?style=flat)](https://circleci.com/gh/icyleaf/terminal-ui.cr)

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

Full methods below:

method | level | description
---|---|---
header | `INFO` | normal default color with table border (Not compatible with emoji)<br />+-----+<br />\|Install\|<br />+-----+
message | `INFO` | normal default color
success | `INFO` | <label style="color:green">green color</label>
important | `WARN` | <label style="color:yellow">yellow color</label>
error | `ERROR` | <label style="color:red">red color</label>
verbose | `DEBUG` | normal default color
deprecated | `WARN` | <label style="color:blue;font-weight:bold">blue with bold color</label>
command | `INFO` | <label style="color:cyan">cyan color</label>
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
  io << "VERBOSE" << datetime.to_s("%F") << message
})

Terminal::UI.message "Welcome to use terminal-ui"
# => "VERBOSE 2017-10-22 Welcome to use terminal-ui"
```

## How to Contribute

Your contributions are always welcome! Please submit a pull request or create an issue to add a new question, bug or feature to the list.

All [Contributors](https://github.com/icyleaf/terminal-ui.cr/graphs/contributors) are on the wall.

## You may also like

- [halite](https://github.com/icyleaf/halite) - HTTP Requests Client with a chainable REST API, built-in sessions and middlewares.
- [totem](https://github.com/icyleaf/totem) - Load and parse a configuration file or string in JSON, YAML, dotenv formats.
- [markd](https://github.com/icyleaf/markd) - Yet another markdown parser built for speed, Compliant to CommonMark specification.
- [poncho](https://github.com/icyleaf/poncho) - A .env parser/loader improved for performance.
- [popcorn](https://github.com/icyleaf/popcorn) - Easy and Safe casting from one type to another.
- [fast-crystal](https://github.com/icyleaf/fast-crystal) - 💨 Writing Fast Crystal 😍 -- Collect Common Crystal idioms.

## License

[MIT License](https://github.com/icyleaf/terminal-ui.cr/blob/master/LICENSE) © icyleaf
