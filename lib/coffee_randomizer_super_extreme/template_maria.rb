require "coffee_randomizer_super_extreme/version"

module CoffeeRandomizerSuperExtreme
  class TemplateMaria
    MIN_NUMBER_OF_PARTICIPANTS = 3
    START_TIME = Time.now
    END_TIME = Time.now + 86400
    ROUND_RETRIES = 100

    def initialize(participants_count)
      @participants_count = participants_count
      @participants = (1..participants_count).to_a
      @tries_per_round = 0
      @tries_per_season = 0
      @log = ::Logger.new("log/test.log")
    end

    def generate_groups
      @rounds = []
      initialize_pair_counters
      while @rounds.count <= num_of_rounds && !season_complete? do

        initialize_round
        while @round.count <= num_of_groups && !season_complete? && @rounds.count <= num_of_rounds && Time.now < END_TIME do

          initialize_group
          form_groups
          if @round.count == num_of_groups
            @rounds << @round
            next_round
          end
        end

        if season_complete?
          print_season_details
          log_season_details
          return true
          break
        end

        if !season_complete?
          if Time.now == END_TIME
            puts "Failed"
            puts "Number of rounds #{@rounds.count}"
            break
          else
            puts "Number of rounds #{@rounds.count}"
            restart_season
          end
        end
      end
    end

    def form_groups
      while @group_participants.count < MIN_NUMBER_OF_PARTICIPANTS && @round.count <= num_of_groups && !season_complete? do
        sum_of_pair_counts = 0

        # select first participant for group
        if @group_participants.empty? && @available_participants.any?
          possible_pair = select_least_paired
          update_group_participants(possible_pair)
        end

        # get sum of pair_counts
        if @available_participants.any?
          possible_pair = @available_participants.shuffle.sample 
          sum_of_pair_counts = sum_of_pair_counts_with(@group_participants, possible_pair)
        end

        # iteration for condition 0,1,2
        while @available_participants.any? do
          if @condition_1 == false && @condition_2 == false
            if sum_of_pair_counts == 0
              update_group_participants(possible_pair)
              group_incomplete? ? set_up_condition_1 : break
            else
              update_skipped(possible_pair)              
              group_incomplete? ? set_up_condition_1 : break
            end
          elsif @condition_1 == true && @condition_2 == false
            if sum_of_pair_counts == 1
              update_group_participants(possible_pair)
              group_incomplete? ? set_up_condition_2 : break
            else
              update_skipped(possible_pair)              
              group_incomplete? ? set_up_condition_2 : break
            end
          elsif @condition_1 == false && @condition_2 == true
            if sum_of_pair_counts == 2
              update_group_participants(possible_pair)
              group_incomplete? ? restart_round : break
            else
              update_skipped(possible_pair)              

              if group_incomplete? && @tries_per_round == ROUND_RETRIES
                puts "Number of rounds #{@rounds.count}"
                restart_season
              elsif group_incomplete? && @tries_per_round < ROUND_RETRIES
                restart_round
              end
              break
            end
          end
        end
      end

      if @tries_per_round == ROUND_RETRIES
        puts "Alternative Restart Season!"
        puts "Number of rounds #{@rounds.count}"
        restart_season
      end

      if @group_participants.count == MIN_NUMBER_OF_PARTICIPANTS
        @round << @group_participants 
        next_group
      end
    end

    #TODO for extra participants
    # def method_name
    #   if group_complete? && round_complete? && @available_participants.any?
    #     possible_pair = @available_participants.shuffle.sample

    #     available_groups = select_available_groups

    #     pair_counters_sum = 
    #     available_groups.each_with_index do |group, i|
    #       group.each do |participant|
    #        sum_of_pair_counts = sum_of_pair_counts_with(group, participant)
    #       end
    #       binding.pry
    #       [i, sum_of_pair_counts]
    #     end
    #     binding.pry
    #   end
    # end

    def sum_of_pair_counts_with(group, possible_pair)
      sum_of_pair_counts = 0
      group.each do |participant|
        sum_of_pair_counts += @pair_counters[participant].count(possible_pair)
      end
      sum_of_pair_counts
    end

    def select_available_groups
      @round.select { |group| group_complete?(group) }
    end

    def select_least_paired
      pair_count_array = @available_participants.map.each_with_index do |participant, i|
        [i, @pair_counters[participant].count]
      end

      lowest_pair_count = pair_count_array.sort_by{|x| x.last}.first
      participant = pair_count_array.reject{|x| x.last != lowest_pair_count.last}.shuffle.pop
      @available_participants[participant.first]
    end

    def log_season_details
      @log.info("Season completed!")
      @log.info("Maria's version")
      @log.info("Number of participants - #{@participants_count}")
      @log.info("Number of rounds - #{@rounds.count}")
      @log.info("Number of groups - #{@rounds.last.count}")
      log_groups
    end

    def print_season_details
      puts "Season completed!"
      puts "Version 2.5"
      puts "Number of participants - #{@participants_count}"
      puts"Number of rounds - #{@rounds.count}"
      puts "Number of groups - #{@rounds.last.count}"
      print_groups
    end

    def print_groups
      @rounds.each_with_index do |round, i|
        puts "Round #{i+1} - #{round}"
      end
    end

    def log_groups
      @rounds.each_with_index do |round, i|
        @log.info("Round #{i+1} - #{round}")
      end     
    end

    def update_group_participants(possible_pair)
      increment_pair_counters(possible_pair)
      add(possible_pair)
    end

    def update_skipped(possible_pair)
      @skipped << possible_pair
      @available_participants -= [@available_participants.delete(possible_pair)]
    end

    def group_incomplete?
      @available_participants.empty? && @group_participants.count < MIN_NUMBER_OF_PARTICIPANTS
    end

    def round_complete?(round)
      round.count == num_of_groups
    end

    def group_complete?(group)
      group.count == MIN_NUMBER_OF_PARTICIPANTS
    end

    def set_up_condition_1
      @condition_1 = true
      @available_participants += @skipped
      @skipped = []
    end

    def set_up_condition_2
      @condition_1 = false
      @condition_2 = true
      @available_participants += @skipped
      @skipped = []
    end

    def max_2_pair_count?
      @pair_counters.map { |k,v| dup_hash(v) }.select {|hash| hash.any? }.count < 1
    end

    def all_attended_in_round?
      @rounds.all? do |round|
        round.flatten.uniq.count == @participants_count
      end
    end

    def dup_hash(ary)
      ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select { 
      |k,v| v > 2 }.inject({}) { |r, e| r[e.first] = e.last; r }
    end

    def next_group
      puts "Next group"
      sum_of_pair_counts = 0
      @group_participants = []
      @available_participants += @skipped
      @skipped = []
    end

    def next_round
      puts "Next round"
      initialize_round
    end

    def restart_round
      @tries_per_round += 1
      puts "Restart round"
      decrement_pair_counters # do this before clearing out round and group
      initialize_group
      initialize_round
    end

    def restart_season
      @tries_per_season += 1
      @tries_per_round = 0
      @rounds = []
      puts "Restart season!"
      puts "#{@tries_per_season}"
      initialize_pair_counters
      initialize_group
      initialize_round
    end

    def season_complete?
      if max_2_pair_count? && has_met_everyone? && all_attended_in_round?
        true
      else
        false
      end
    end

    def has_met_everyone?
      @participants.all? do |participant| 
        @pair_counters[participant].uniq.count == @participants_count - 1
      end
    end

    def add(possible_pair)
      @group_participants << possible_pair
      @available_participants -= [@available_participants.delete(possible_pair)]
    end

    def increment_pair_counters(possible_pair)
      @group_participants.each do |group_participant|
        @pair_counters[group_participant] << possible_pair
        @pair_counters[possible_pair] << group_participant
      end
    end

    def decrement_pair_counters
      @round.each do |group|
        group.each do |participant|
          @pair_counters[participant].pop(1)
        end
      end
    end

    def initialize_pair_counters
      @pair_counters = {}
      @participants.map { |id| @pair_counters[id] = [] }
    end

    def initialize_group
      @group_participants = []
      @condition_1 = false
      @condition_2 = false
    end

    def initialize_round
      @skipped = []
      @round = []
      @available_participants = @participants.dup
    end

    def num_of_rounds
      num_of_rounds = (@participants_count - 1).to_f / (3 - 1).to_f
      num_of_rounds.ceil
    end 

    def num_of_groups
      (@participants_count.to_f / MIN_NUMBER_OF_PARTICIPANTS.to_f).floor
    end
  end
end
