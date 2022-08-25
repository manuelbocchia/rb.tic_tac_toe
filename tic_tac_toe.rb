# separate module for winning and tied games
module Endgame
  def is_won?(symbol)
    if places[1] == symbol && places[2] == symbol && places[3] == symbol
      true
    elsif places[4] == symbol && places[5] == symbol && places[6] == symbol
      true
    elsif places[7] == symbol && places[8] == symbol && places[9] == symbol
      true
    elsif places[1] == symbol && places[4] == symbol && places[7] == symbol
      true
    elsif places[2] == symbol && places[5] == symbol && places[8] == symbol
      true
    elsif places[3] == symbol && places[6] == symbol && places[9] == symbol
      true
    elsif places[1] == symbol && places[5] == symbol && places[9] == symbol
      true
    elsif places[3] == symbol && places[5] == symbol && places[7] == symbol
      true
    else
      false
    end
  end

  def is_tied?(places)
    true if places.none? { |_key, val| val == '_' }
  end
end

# this class creates the game to be played where we hold the final score
# the play_game method creates Play objects to play the rounds, and checks for winning condition after each round
class Game
  attr_accessor :player1_score, :player2_score

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @player1_score = 0
    @player2_score = 0
  end

  def play_game
    while @player1_score < 3 || @player2_score < 3
      round = Play.new
      round.play_round(self, @player1, @player2)
      break if player1_score == 3 || player2_score == 3
    end
    if @player1_score == 3
      puts "#{@player1} has won the game! Congratulations!"
    elsif @player2_score == 3
      puts "#{@player2} has won the game! Congratulations!"
    end
  end
end

# this class instanciates the board and has the method for playing the rounds
# it's missing:
class Play
  include Endgame
  attr_reader :places, :board

  @@number_board = " 1|2|3 \n 4|5|6 \n 7|8|9 "
  def initialize
    @places = {}
    for i in (1..9) do
      @places[i] = '_'
      end
    @board = " #{places[1]}|#{places[2]}|#{places[3]} \n #{places[4]}|#{places[5]}|#{places[6]} \n #{places[7]}|#{places[8]}|#{places[9]}"
  end

  def choose(symbol)
    player_choice = gets.chomp.to_i
    while @places[player_choice] != '_'
      puts 'Space not open! Choose again.'
      player_choice = gets.chomp.to_i
    end
    @places[player_choice] = symbol
    new_board
    puts board
  end

  def new_board
    @board = " #{places[1]}|#{places[2]}|#{places[3]} \n #{places[4]}|#{places[5]}|#{places[6]} \n #{places[7]}|#{places[8]}|#{places[9]}"
  end

  def play_round(game, player1, player2)
    puts @@number_board
    puts 'Choose!'
    while is_won?('X') != true || is_won?('O') != true || is_tied? != true
      puts "#{player1} chooses"
      choose('X')
      break if is_won?('X') == true || is_tied?(places)

      puts "#{player2} chooses"
      choose('O')
      break if is_won?('O') == true || is_tied?(places)
    end
    if is_won?('X')
      puts "#{player1} wins this round!"
      puts board
      game.player1_score += 1
      puts "Score: #{player1} = #{game.player1_score} points - #{player2} = #{game.player2_score} points"
    elsif is_won?('O')
      puts "#{player2} wins this round!"
      puts board
      game.player2_score += 1
      puts "Score: #{player1} = #{game.player1_score} points - #{player2} = #{game.player2_score} points"
    elsif is_tied?(places)
      puts board
      puts 'Game is tied! Play again.'
    end
  end
end

# UI messages for the players

puts "Welcome to Tic-Tac-Toe! \n It's time to test your skills!"
puts 'Write the name of player 1'
player1 = gets.chomp
puts "#{player1}, you'll be X"
puts "Enter the second player's name."
player2 = gets.chomp
puts "#{player2} you are the O, then."
puts "Best of 5.\n Let's begin."

# couldn't think of a better way of looping the game back to the beginning
loop do
  game1 = Game.new(player1, player2)
  game1.play_game
  puts 'Play again?'
  puts 'Write Y/N'
  answer = gets.chomp
  break if answer.match?(/n/i)
end
