# frozen_string_literal: true

namespace :game do
  desc 'Start a new game'
  task start: :environment do
    Game::Start.call
  end

  desc 'Progress the running games'
  task run: :environment do
    puts 'Progress all games'

    loop do
      Game::ProgressAll.call

      sleep 0.12
    end
  end

  desc 'Progress the running games using RailsPermanentJob'
  task run_with_permanent_job: :environment do
    RailsPermanentJob.jobs = [Game::ProgressAll]
    RailsPermanentJob.after_job = ->(**_options) { sleep 0.2 }

    log_level = ENV['LOG_LEVEL'].presence || 'info'
    RailsPermanentJob.run(workers: 1, log_level:)
  end
end
