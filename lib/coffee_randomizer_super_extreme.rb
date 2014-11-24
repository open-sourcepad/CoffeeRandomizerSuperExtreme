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
    @member_count = args[:member_count]
    @incompatible_count = args[:incompatible_count]
    @log = ::Logger.new("log/results.log")
    @results = {}
    generate
  end

  private

  def generate
    am = Template.new({member_count: @member_count,
                       incompatible_count: @incompatible_count})
    start_time = Time.now
    succeed = am.generate
    end_time = Time.now
    print_results(start_time,end_time, succeed, am)
  end

  def print_results(start_time, end_time, succeed, am)
    @results[@member_count] = {}
    @results[@member_count][:result] = succeed
    @results[@member_count][:check_pairs] = am.check_pairs
    @results[@member_count][:number_of_rounds] = am.number_of_rounds
    @results[@member_count][:number_of_original_rounds] = am.number_of_original_rounds
    @results[@member_count][:number_of_groups] = am.number_of_groups
    @results[@member_count][:max_tries_per_season] = am.max_tries_per_season
    @results[@member_count][:round_increment] = am.round_increment
    @results[@member_count][:incompatibles] = am.incompatibles
    @results[@member_count][:time] = (end_time - start_time) * 1000
    @log.info "========= Results for #{@member_count} ========="
    @results[@member_count].keys.each do |r|
      @log.info "#{r}: #{@results[@member_count][r]}"
    end
  end

end
