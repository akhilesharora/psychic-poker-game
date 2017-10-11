#!/usr/bin/env ruby
load 'pyscho.rb'

begin
	if ARGV.size < 2
    where = ARGV.size == 0 ? "Input" : "Output"
    raise ArgumentError

  end

  input_file = File.open(ARGV[0])
  output_file = File.open(ARGV[1], "w")

  input_file.read.split("\n").each do |line|
    line = line.split(" ")
    game = Pyscho.new(line[0, 5], line[5, 5])
    hand, deck, best_hand = game.cards_in_hand.join(' '), game.cards_in_deck.join(' '), game.best_hand
    output_file.write "Hand: #{hand} Deck: #{deck} Best hand: #{best_hand}\n"
  end

  
  rescue ArgumentError
    puts "#{where} file not found."
  rescue TypeError
    puts "Issue with File Handling"
  rescue NoMethodError
    puts "File not opened"
  rescue Exception => e
  	puts "Something bad happened"
ensure
	[input_file,output_file].each{|file| file.close}
end


