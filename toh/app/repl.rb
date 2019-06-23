require_relative 'game'
require_relative 'graphics'

class Repl
  def initialize
    @graphics = Graphics.new
    @moves_counter = 0
  end

  def run
    welcome
    run_game_loop
    goodbye
  end

  private

  attr_reader :game, :graphics, :moves_counter

  def welcome
    puts "Welcome to the Tower of Hanoi. Please enter the number of rings"
    prompt
    rings = Integer(gets.chomp)
    puts "you have chosen #{rings} rings"
    @game = Game.new(rings)
    help
  end

  def run_game_loop
    loop do
      prompt
      break if handle(get_line) == :stop
    end
  end

  def help
    puts <<-EOS
  'help'     - prints this help message
  'exit'     - quits the game
  'print'    - prints the current state
  'move x y' - attempts to move a ring from pole x to pole y
    EOS
  end

  def handle(instruction)
    cmd = instruction[:command]
    case cmd
    when 'help'
      help
    when 'exit'
      return :stop
    when 'print'
      graphics.draw(game)
    when 'move'
      handle_move(instruction[:args])
    else
      puts "ERROR: Unrecognized command [#{cmd}]"
      help
    end
  end

  def handle_move(poles)
    @moves_counter += 1
    if poles.length != 2
      puts 'ERROR: must enter source pole and destination pole'
      help
      return
    end

    from, to = poles[0].to_i, poles[1].to_i

    if from < 1 || from > 3
      puts 'ERROR: source pole must be valid'
      help
      return
    end

    if to < 1 || to > 3
      puts 'ERROR: destination pole must be valid'
      help
      return
    end

    error = game.move(from, to)
    if error
      puts "ERROR: #{error}"
    else
      graphics.draw(game)
    end

    if game.wins?
      winner
      :stop
    end
  end

  def winner
    puts "CONGRATULATIONS! You have won in #{moves_counter} total moves!!!!!"
  end

  def prompt
    print "toh> "
  end

  def get_line
    first, *rest = gets.chomp.strip.split(/\s+/)
    {
      command: first,
      args:    rest,
    }
  end

  def goodbye
    puts 'Thank you for playing and have a nice day!'
  end
end