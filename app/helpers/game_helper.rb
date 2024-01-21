# frozen_string_literal: true

module GameHelper
  def game_cell(cell, with_frog, with_train)
    deadly_pattern(cell) || railway(cell, with_frog, with_train) || gravel(cell, with_frog) || water(with_frog)
  end

  private

  def deadly_pattern(cell)
    case cell
    when Game::World::PATTERN_TNT then image_tag('water_with_tnt.png')
    when Game::World::PATTERN_VIOLET_MONSTER then image_tag('water-with-violet-monster.png')
    when Game::World::PATTERN_BLACK_MONSTER then image_tag('water-with-black-monster.png')
    when Game::World::PATTERN_GREEN_MONSTER then image_tag('water-with-green-monster.png')
    end
  end

  def railway(cell, with_frog, with_train)
    return nil unless cell == Game::World::PATTERN_RAILWAY

    if with_train
      image_tag('rails_with_train_double--left.png') + image_tag('rails_with_train_double--right.png')
    elsif with_frog
      image_tag('rails_with_frog-green.png')
    else
      image_tag('rails-green.png')
    end
  end

  def gravel(cell, with_frog)
    return nil unless cell == Game::World::PATTERN_GRAVEL

    if with_frog
      image_tag('gravel_with_frog.png')
    else
      image_tag('gravel.png')
    end
  end

  def water(with_frog)
    if with_frog
      image_tag('water_with_frog.png', alt: 'Frog on the water')
    else
      '<div style="background-color: #357cea;"></div>'.html_safe
    end
  end
end
