require 'yaml'

class Game
  attr_reader :word
  attr_accessor :answer, :win

  def initialize
    @answer = []
    words = File.open('../words.txt').to_a
    while true
      word = words[rand(0..words.size)].to_s
      if word.length.between?(6,13)
        word.strip!
        @word = word.upcase
        break
      end
    end
    (@word.length).times do
      @answer << '_'
    end
  end

  def give_word
    @word
  end

  def print_answer
    print @answer
  end

  def validate_guess(guess)
    for i in (0..@word.length) do
      if @word[i] == guess
        @answer[i] = guess
      end
    end
  end

  def win?
    if @word.to_s == @answer.join
      @win = true
    else
      @win = false
    end
  end
end

class Player
  attr_accessor :player_name, :guess, :tries
  def initialize(name)
    @player_name = name
    @tries = 12
    @guess = []
  end
  def start_game
    @tries = 12
  end
  def add_guess(guess)
    @guess << guess
  end
  def play
    @tries -= 1
  end
end

#Start Game and pick the Word
puts '---- Game is starting ----'
puts 'Chose New Game or Load'
choice = gets.chomp.downcase
if choice == 'load'
  puts 'Give me a name:'
  save_game = gets.chomp
  content = File.open( "../save/#{save_game}.yaml", 'r') { |file| file.read }
  ld = YAML::load(content)
  p = ld[0]
  g = ld[1]
  i = p.tries
else
  puts 'Pls tell me your name'
  player = gets.chomp
  g = Game.new
  print g.give_word
  p = Player.new(player)
  g.print_answer
  i = p.start_game
end
while i > 0
  if g.win?
    puts "Congratz #{p.player_name} YOU WIN !"
    break
  end
  puts "#{p.player_name} try to guess my word"
  guess = gets.chomp.to_s.upcase
  if guess == 'SAVE'
    print 'SaveGame Name:'
    save_game = gets.chomp
    vars = [p,g]
    save = YAML::dump(vars)
    File.open( "../save/#{save_game}.yaml", 'w') {|f| f.write(save) }
    puts "Saved #{save_game} !"
    break
  end
  g.validate_guess(guess)
  g.print_answer
  i = p.play
  p.add_guess(guess)
  print "#{p.player_name} you have tried this letters: #{p.guess}"
  puts "#{p.player_name} you have #{i} tyes remaining"
  p g.answer.join
  p g.word

end
puts "Game Over #{p.player_name}, You Loose" if i == 0