require "coffee_randomizer_super_extreme/template_helper"
require "coffee_randomizer_super_extreme/pair_manager"
require "coffee_randomizer_super_extreme/template"
require 'active_support'
require 'active_support/core_ext/numeric/time.rb'

require 'logger'
require 'pry'

class CoffeeRandomizerSuperExtreme
  attr_reader :results, :template

  def initialize(args)
    args = args.symbolize_keys
    @members = args[:members]
    @incompatibles = args[:incompatibles]
    @log = ::Logger.new("log/results.log")
    @results = {}
    generate
  end

  private

  def generate
    am = Template.new({members: @members,
                       incompatibles: @incompatibles})
    start_time = Time.now
    succeed = am.generate
    end_time = Time.now
    print_results(start_time,end_time, succeed, am)
  end

  def print_results(start_time, end_time, succeed, am)
    @results[@members.size] = {}
    @results[@members.size][:result] = succeed
    @results[@members.size][:check_pairs] = am.check_pairs
    @results[@members.size][:number_of_rounds] = am.number_of_rounds
    @results[@members.size][:number_of_original_rounds] = am.number_of_original_rounds
    @results[@members.size][:number_of_groups] = am.number_of_groups
    @results[@members.size][:max_tries_per_season] = am.max_tries_per_season
    @results[@members.size][:round_increment] = am.round_increment
    @results[@members.size][:incompatibles] = am.incompatibles
    @results[@members.size][:time] = (end_time - start_time) * 1000
    @log.info "========= Results for #{@members.size} ========="
    @results[@members.size].keys.each do |r|
      @log.info "#{r}: #{@results[@members.size][r]}"
    end
  end

end
