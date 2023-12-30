namespace :game do
  desc "Start a new active game"
  task start: :environment do
    StartGameService.call
  end

  desc "Progress the active game"
  task run: :environment do
    puts 'Starting game'
    loop do
      ProgressGameService.call

      sleep 0.25
    end
  end
end
