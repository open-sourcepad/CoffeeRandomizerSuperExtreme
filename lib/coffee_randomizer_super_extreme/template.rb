module CoffeeRandomizerSuperExtreme
  class Template
    attr_accessor :min_number_per_group, :max_tries_per_round, :season, :pair_manager

    def initialize(count, increment_max=3, time=600)
      @min_number_per_group = 3
      @max_tries_per_round  = 1000
      @max_pair_count = 2
      @participants = (1..count).to_a
      @sum_of_pair_counts = (0..(@max_pair_count+1))
      @log = ::Logger.new("log/test.log")
      @round_increment = 0
      @complete = false
      @increment_max = increment_max
      @pair_manager = CoffeeRandomizerSuperExtreme::PairManager.new(@participants)
      @time = time
      @end_time = Time.now + @time.seconds
    end

    def generate
      while @round_increment <= @increment_max and @complete == false
        new_season
        while @season.count < number_of_rounds and Time.now < @end_time
          initialize_round_requirements
          while @round.count < number_of_groups and @tries_per_round < @max_tries_per_round
            assign_round_groups
            check_for_round_skips
          end
          if !@available.empty?
            assign_extra_participants
            restart_round if !@skipped.empty? or !@available.empty?
          end
          season_check
        end
        check_for_retry_limit
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
      @pair_manager.check_pairs
    end

    private

      def initialize_round_requirements
        @available = @participants.dup
        @skipped = []
        @round = []
      end

      def accept_to_group(group, target, sum_pair_count)
        pairs = group.map.each do |participant|
          @pair_manager.get_pair_count(participant, target)
        end
        sum = pairs.inject(&:+).to_i
        sum == sum_pair_count and pairs.select{|p| p == @max_pair_count}.empty?
      end

      def assign_round_groups
        @group = []
        assignment_logic(@min_number_per_group)
      end

      def assign_extra_participants
        @round.each do |g|
          @group = g
          assignment_logic(@min_number_per_group + 1)
        end
      end

      def assignment_logic(minimum_group_count)
        @sum_of_pair_counts.each do |condition|
          @skipped = []
          @available.shuffle.each do |participant|
            break if @group.count == minimum_group_count
            if accept_to_group(@group, participant, condition)
              @pair_manager.add_group_to_pairs(@group, participant)
              @available.delete participant
              @group << participant
            else
              @skipped << participant
            end
          end
          if @group.count == minimum_group_count
            @skipped = []
          end
        end
      end

      def check_for_round_skips
        if !@skipped.empty?
          restart_round
        else
          next_group
        end
      end

      def restart_round
        @tries_per_round += 1
        initialize_round_requirements
        @pair_manager.rebuild_pair_manager(@season)
      end

      def next_group
        @available = @available + @skipped
        @skipped.clear
        @round << @group
      end

      def season_check
        if (@tries_per_round >= @max_tries_per_round) or
            (@season.count == number_of_rounds-1 and
             (check_pairs.uniq.count > 1 or
              (check_pairs.uniq.count == 1 and
               check_pairs.uniq.first != @participants.length-1)))
          @round = []
          new_season
        else
          @season << @round
        end
      end

      def new_season
        @season = []
        @tries_per_round = 0
        @pair_manager.rebuild
      end

      def check_for_retry_limit
        if Time.now >= @end_time
          @end_time = Time.now + @time.seconds
          @complete = false
          @round_increment += 1
        else
          @complete = @season.map{|round| round.map{|group| group.map{|participant| participant}}}
        end
      end
  end
end
