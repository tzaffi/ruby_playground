class Ring
  attr_reader :width

  def initialize(width, num_rings)
    @width     = width
    @num_rings = num_rings
  end

  def to_s
    "#{margin}#{'<' * width}||#{'>' * width}#{margin}"
  end

  private

  def margin
    ' ' * (num_rings - width)
  end

  attr_accessor :num_rings
end