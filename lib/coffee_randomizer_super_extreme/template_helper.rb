class CoffeeRandomizerSuperExtreme
  module TemplateHelper
    def number_of_rounds
      ((@participants.length - 1.to_f) / (min_number_per_group - 1.to_f)).ceil + round_increment
    end

    def number_of_original_rounds
      ((@participants.length - 1.to_f) / (min_number_per_group - 1.to_f)).ceil
    end

    def number_of_groups
      (@participants.length / min_number_per_group.to_f).floor
    end

    def check_pairs
      pair_manager.check_pairs
    end

    private

    def initialize_variables(args)
      @increment_max = 10
      @participants = args[:members]
      @log = ::Logger.new("log/test.log")
      @round_increment = 0
      @complete = false
      @pair_manager = PairManager.new(@participants)
      @min_number_per_group = 3
      @incompatibles = args[:incompatibles] ? args[:incompatibles] : {}
      @max_pair_count = @incompatibles.empty? ? 2 : 3
      @sum_of_pair_counts = (0..(max_pair_count+1))
    end

    def initialize_round_requirements
      @available = @participants.dup
      @skipped = []
      @round = []
    end

    def restart_round
      @tries_per_round += 1
      initialize_round_requirements
      pair_manager.rebuild_pair_manager(season)
    end

    def next_group
      @available = @available + @skipped
      @skipped.clear
      @round << @group
    end

    def new_season
      @season = []
      @tries_per_round = 0
      pair_manager.rebuild
    end

    def season_check_incompatibles
      season.count == number_of_rounds-1 and
        !pair_manager.everyone_met_check(@incompatibles)
    end

    def season_check_regular
      (season.count == number_of_rounds-1 and
       (check_pairs.uniq.count > 1 or
        (check_pairs.uniq.count == 1 and
         check_pairs.uniq.first != @participants.length-1)))
    end

    def accept_to_group_condition(args)
      if @incompatibles.empty?
        args[:sum] == args[:sum_pair_count] and
          args[:pairs].select{|p| p == @max_pair_count}.empty?
      else
        args[:sum] == args[:sum_pair_count] and all_compatible(args)
      end
    end

    private

    def all_compatible(args)
      compatible = true
      group = (args[:group] + [args[:target]])
      group.each do |participant|
        compatible = false if incompatibles[participant] and (incompatibles[participant] & group).size > 0
      end
      compatible
    end
  end
end
