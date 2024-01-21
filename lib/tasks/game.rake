# frozen_string_literal: true

namespace :game do
  desc 'Start a new game'
  task start: :environment do
    Game::Start.call
  end

  desc 'Progress the running games'
  task progress: :environment do
    puts 'Progress all games'
    loop do
      Game::ProgressAll.call

      sleep 0.25
    end
  end
end
