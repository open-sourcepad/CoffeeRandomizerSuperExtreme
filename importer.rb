require 'rubygems' 
require 'bundler/setup' 
require 'coffee_randomizer_super_extreme'
Bundler.setup

puts "Enter Participant Count: (must be multiples of 3 i.e. 9 / 15/ 21 / 27 / 33 / etc.)"
count = gets.chomp

generator = CoffeeRandomizerSuperExtreme::TemplateMaria.new(count.to_i)
generator.generate_groups