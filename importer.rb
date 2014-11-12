require 'rubygems' 
require 'bundler/setup' 
require 'coffee_randomizer_super_extreme'
Bundler.setup

time = 3600
from = 51
to = 100
  tb = CoffeeRandomizerSuperExtreme::TestBed.new(time.to_i)
  tb.start((from.to_i..to.to_i), 10)
  @results = tb.results

  puts "=========RESULTS========="
  (from.to_i..to.to_i).each do |i|
    puts "########## Result for #{i} ##########"
    @results[i].keys.each do |key|
      puts "#{key}: #{@results[i][key]}"
    end
  end
