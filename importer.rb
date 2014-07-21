require 'rubygems' 
require 'bundler/setup' 
require 'coffee_randomizer_super_extreme'
Bundler.setup

try_again = true
while try_again
  from = to = 0
  puts "Enter Range:"
  while from.to_i <= 0 and to.to_i <= 0
    puts "From: "
    from = gets.chomp
    puts "Until:"
    to = gets.chomp
    if from.to_i <= 0 and to.to_i <= 0
      puts "Invalid range (#{from} until #{to}). Please try again."
    end
  end
  tb = CoffeeRandomizerSuperExtreme::TestBed.new
  tb.start(from.to_i..to.to_i)
  @results = tb.results

  puts "=========RESULTS========="
  (from.to_i..to.to_i).each do |i|
    puts "########## Result for #{i} ##########"
    @results[i].keys.each do |key|
      puts "#{key}: #{@results[i][key]}"
    end
  end
  puts "========================="
  puts "Try again? (true / false)"
  try_again = eval(gets.chomp)
end
