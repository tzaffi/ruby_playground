require './ring'

class Game
  attr_reader :n

  def initialize(n)
    @n     = n
    @poles = Array.new(3) { [] }
    n.downto(1).each do |width|
      poles[0] << Ring.new(width, n)
    end
  end

  def poles
    @poles.clone
  end

  def move(from, to)
    return "cannot move when from/to are the same (#{from})" if from == to

    from_pole, to_pole = poles[from -1], poles[to - 1]


    if from_pole.length == 0
      return "there is no ring on pole #{from}"
    end

    if to_pole.empty? || to_pole[-1].width > from_pole[-1].width
      to_pole.push(from_pole.pop)
      puts "#from_pole: #{from_pole.length}, #to_pole: #{to_pole.length}"
      return
    end

    'cannot put on top of narrower ring'
  end

  def wins?
    poles[-1].length == n
  end
end