# Ruby on Rails - the Game

This application is the subject of workshops organized for Ruby Warsaw Community Conference 2024. It tells an intense story of a love interrupted by evil magic. Will the Prince David rescue Princess Ruby?

Disclaimer: This code was created for fun and for fun only. It has obvious design flaws and is not perfect by any standards. But it was awesome to write and to share with all Ruby fans.

## Installation
```sh
# Clone the repository
$ git clone https://github.com/pstrzalk/ruby-on-rails-game
$ cd ruby-on-rails-game

# Install gems
$ bundle

# Create database and run migrations
$ bin/setup

# Run game server
$ bin/dev

# [In another terminal] Run game loop
$ rails game:run

# Open in a browser
$ open http://localhost:3000
```

## Testing

This application uses Minitest library for testing purposes. Run the following instruction and always keep the overall test coverage at 100% (and beyond).

```sh
$ rails test
```

## Keep the code readable

The application uses Rubocop as code linter. Please run

```sh
$ rubocop
```

and keep the output free of offenses.

## Have fun

Is obligatory!
