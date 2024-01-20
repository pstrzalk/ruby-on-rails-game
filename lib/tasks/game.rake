# frozen_string_literal: true

namespace :game do
  desc 'Start a new running game'
  task start: :environment do
    StartGameService.call
  end

  desc 'Progress the running game'
  task run: :environment do
    puts 'Starting game'
    loop do
      ProgressGameService.call

      sleep 0.25
    end
  end
end
