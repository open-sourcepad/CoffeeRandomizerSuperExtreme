module CoffeeRandomizerSuperExtreme
  class TemplateNormz
    attr_accessor :min_number_per_group, :max_tries_per_round, :season, :pair_manager

    def initialize(count, increment_max=3)
      @min_number_per_group = 3
      @max_tries_per_round  = 1000
      @max_pair_count = 2
      @participants = (1..count).to_a
      @sum_of_pair_counts = (0..(@max_pair_count+1))
      @log = ::Logger.new("log/test.log")
      @round_increment = 0
      @complete = false
      @increment_max = increment_max
    end

    def generate
      while @round_increment <= @increment_max and @complete == false
        log_me "#{Time.now}:BEGIN - Generation"
        new_season
        end_time = Time.now + 600
        while @season.count < number_of_rounds and Time.now < end_time
          initialize_round_requirements
          log_me "Round: #{@season.count + 1} / #{number_of_rounds}"
          while @round.count < number_of_groups and @tries_per_round < @max_tries_per_round
            log_me "Group: #{@round.count + 1} / #{number_of_groups}"
            log_me "Unique Pair Counts: #{check_pairs.uniq}"
            assign_round_groups
            check_for_round_skips
          end
          if !@available.empty?
            assign_extra_participants
            restart_round if !@skipped.empty? or !@available.empty?
          end
          season_check
        end
        log_me "#{Time.now}:END - Generation"
        if Time.now >= end_time
          @complete = false
          @round_increment += 1
          puts "increase round increment by 1: #{@round_increment}"
        else
          @complete = @season.map{|round| round.map{|group| group.map{|participant| participant}}}
        end
      end
      @complete
    end

    def number_of_rounds
      ((@participants.length - 1.to_f) / (@min_number_per_group - 1.to_f)).ceil + @round_increment
    end

    def number_of_original_rounds
      ((@participants.length - 1.to_f) / (@min_number_per_group - 1.to_f)).ceil
    end

    def number_of_groups
      (@participants.length / @min_number_per_group.to_f).floor
    end

    def check_pairs
      @pair_manager.map{|key, val| val.uniq.count}
    end

    private

      def initialize_round_requirements
        @available = @participants.dup
        @skipped = []
        @round = []
        log_me "==="
        log_me "Initialize Round Requirements"
        log_me "<<<"
      end

      def get_pairs(participant, possible_pair)
        @pair_manager[participant].select{|me| me == possible_pair}
      end

      def add_group_to_pairs(group, target)
        group.each do |possible_pair|
          @pair_manager[target] << possible_pair
          @pair_manager[possible_pair] << target
        end
      end

      def accept_to_group(group, target, sum_pair_count)
        pairs = group.map.each do |participant|
          get_pairs(participant, target).count
        end
        sum = pairs.inject(&:+).to_i
        sum == sum_pair_count and pairs.select{|p| p == @max_pair_count}.empty?
      end

      def assign_round_groups
        @group = []
        log_me "==="
        log_me "Assign Round Groups"
        assignment_logic(@min_number_per_group)
        log_me "<<<"
      end

      def assign_extra_participants
        log_me "==="
        log_me "Assign Extra Participants"
        @round.each do |g|
          log_me "Group: #{g}"
          @group = g
          assignment_logic(@min_number_per_group + 1)
        end
        log_me "<<<"
      end

      def assignment_logic(minimum_group_count)
        @sum_of_pair_counts.each do |condition|
          log_me "Applying condition #{condition}"
          @skipped = []
          @available.shuffle.each do |participant|
            break if @group.count == minimum_group_count
            log_me "---"
            log_me "Random Person: #{participant}"
            if accept_to_group(@group, participant, condition)
              log_me "Add #{participant} to group #{@group.inspect}"
              add_group_to_pairs(@group, participant)
              @available.delete participant
              @group << participant
            else
              log_me "Skip #{participant}"
              log_me "Group: #{@group.inspect}"
              log_me "Condition: #{condition}"
              @skipped << participant
            end
            log_me "---"
          end
          if @group.count == minimum_group_count
            @skipped = []
          end
        end
      end

      def check_for_round_skips
        log_me "==="
        log_me "Check for Skipped participants in the round"
        if !@skipped.empty?
          log_me "FAIL: There are skipped participants"
          log_me "Skipped: #{@skipped.inspect}"
          log_me "Group: #{@group.inspect}"
          restart_round
        else
          next_group
        end
        log_me "<<<"
      end

      def restart_round
        @tries_per_round += 1
        log_me "Tries Per Round:#{@tries_per_round}"
        initialize_round_requirements
        rebuild_pair_manager
      end

      def rebuild_pair_manager
        @participants.each do |p|
          @pair_manager[p] = []
          @season.each do |round|
            round.each do |group|
              group.each do |participant|
                @pair_manager[p] << participant if p != participant and group.include?(p)
              end
            end
          end
        end
      end

      def next_group
        @available = @available + @skipped
        @skipped.clear
        @round << @group
      end

      def season_check
        if @tries_per_round >= @max_tries_per_round
          log_me "FAIL: Tries per Round exceeded"
          @round = []
          new_season
        else
          @season << @round
          log_me "SUCCESS: Round accepted"
          log_me "Round: #{@round.map{|me| me}}"
        end
        if(@season.count == number_of_rounds and
           (check_pairs.uniq.count > 1 or
            (check_pairs.uniq.count == 1 and
             check_pairs.uniq.first != (@participants.length - 1))))
          log_me "FAIL: Season ended but not everyone met each other"
          @round = []
          new_season
        end
      end

      def new_season
        @season = []
        @tries_per_round = 0
        @pair_manager = {}
        @participants.each do |p|
          @pair_manager[p] = []
        end
      end

      def log_me(string)
        #@log.debug(string)
        #puts string
      end
  end
end
