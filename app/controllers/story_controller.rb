# frozen_string_literal: true

class StoryController < ApplicationController
  def index; end

  def show
    @part = params[:id]
  end
end
