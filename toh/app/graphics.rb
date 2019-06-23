class Graphics
  EXTRA_HEIGHT = 5

  def draw(game)
    # one, two, three = game.poles
    idx = game.n + EXTRA_HEIGHT - 1
    while idx >= 0
      game.poles.each do |pole|
        if idx >= pole.length
          draw_empty(game.n)
        else
          draw_ring(pole[idx])
        end
      end
      puts ''
      idx -= 1
    end
    draw_bottom(game.n)
  end

  private

  def draw_empty(width)
    print ' ' * width + '||' + ' ' * width
  end

  def draw_bottom(width)
    line = '=' * (6 * width + 6)
    puts "#{line}\n"
  end

  def draw_ring(ring)
    print ring
  end
end