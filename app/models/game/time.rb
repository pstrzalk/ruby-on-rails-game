# frozen_string_literal: true

class Game < ApplicationRecord
  class Time < ApplicationRecord
    belongs_to :game

    def progress
      self.current += 1
    end
  end
end
