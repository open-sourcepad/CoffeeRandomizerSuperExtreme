module CoffeeRandomizerSuperExtreme
  class TemplateGenerator
    attr_accessor :min_number_per_group, :max_tries_per_round, :max_tries_per_season, 
                  :season, :pair_manager, :tries_per_season

    def initialize(count)
      @min_number_per_group = 3
      @max_tries_per_round  = 1000
      @max_tries_per_season = 1000
      @max_pair_count = 2
      @participants = (1..count).to_a
      @sum_of_pair_counts = (0..(@max_pair_count+1))
      @log = ::Logger.new("log/test.log")
    end

    def generate
      @log.debug "#{Time.now}:BEGIN - Generation"
      @tries_per_season = 0
      new_season
      while @season.count < number_of_rounds and @tries_per_season < @max_tries_per_season
        initialize_round_requirements
        @log.debug "Round: #{@season.count + 1} / #{number_of_rounds}"
        while @round.count < number_of_groups and @tries_per_round < @max_tries_per_round
          @log.debug "Group: #{@round.count + 1} / #{number_of_groups}"
          @log.debug "Unique Pair Counts: #{check_pairs.uniq}"
          assign_round_groups
          check_for_round_skips
        end
        if !@available.empty?
          assign_extra_participants
          restart_round if !@skipped.empty? or !@available.empty?
        end
        season_check
      end
      @log.debug "#{Time.now}:END - Generation"
      @tries_per_season >= @max_tries_per_season ? false : @season.map{|round| round.map{|group| group.map{|participant| participant}}}
    end

    def number_of_rounds
      ((@participants.length - 1.to_f) / (@min_number_per_group - 1.to_f)).ceil
    end

    def number_of_groups
      (@participants.length / @min_number_per_group.to_f).floor
    end
      
    def check_duplicates(participant=nil)
      hash = {}
      @pair_manager.each do |key, val|
        inner_hash = {}
        val.each do |v|
          inner_hash[v] = val.select{|iv| iv == v}.count
        end
        hash[key] = inner_hash
      end
      participant ? hash[participant] : hash
    end
    
    def check_pairs
      @pair_manager.map{|key, val| val.uniq.count}
    end
    
    def check_array
      hash = []
      @round.each do |g|
        inner_hash = {}
        g.each do |p|
          inner_hash[p] = @pair_manager[p]
        end
        hash << inner_hash
      end
      hash
    end

    private

      def initialize_round_requirements
        @available = @participants.dup
        @skipped = []
        @round = []
        @log.debug "==="
        @log.debug "Initialize Round Requirements"
        @log.debug "<<<"
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
        @log.debug "==="
        @log.debug "Assign Round Groups"
        assignment_logic(@min_number_per_group)
        @log.debug "<<<"
      end
      
      def assign_extra_participants
        @log.debug "==="
        @log.debug "Assign Extra Participants"
        @round.each do |g|
          @log.debug "Group: #{g}"
          @group = g
          assignment_logic(@min_number_per_group + 1)
        end
        @log.debug "<<<"
      end
      
      def assignment_logic(minimum_group_count)
        @sum_of_pair_counts.each do |condition|
          @log.debug "Applying condition #{condition}"
          @skipped = []
          @available.shuffle.each do |participant|
            break if @group.count == minimum_group_count
            @log.debug "---"
            @log.debug "Random Person: #{participant}"
            if accept_to_group(@group, participant, condition)
              @log.debug "Add #{participant} to group #{@group.inspect}"
              add_group_to_pairs(@group, participant)
              @available.delete participant
              @group << participant
            else
              @log.debug "Skip #{participant}"
              @log.debug "Group: #{@group.inspect}"
              @log.debug "Condition: #{condition}"
              @log.debug "Check Duplicates: #{check_duplicates(participant).inspect}"
              @skipped << participant
            end
            @log.debug "---"
          end
          if @group.count == minimum_group_count
            @skipped = []
          end
        end
      end

      def check_for_round_skips
        @log.debug "==="
        @log.debug "Check for Skipped participants in the round"
        if !@skipped.empty?
          @log.debug "FAIL: There are skipped participants"
          @log.debug "Skipped: #{@skipped.inspect}"
          @log.debug "Group: #{@group.inspect}"
          @log.debug "Check Duplicates: #{check_duplicates.inspect}"
          restart_round
        else
          next_group
        end
        @log.debug "<<<"
      end

      def restart_round
        @tries_per_round += 1
        @log.debug "Tries Per Round:#{@tries_per_round}"
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
          @tries_per_season += 1
          @log.debug "FAIL: Tries per Round exceeded" 
          @log.debug "Increase Try per Season - Total:#{@tries_per_season}"
          @round = []
          new_season
        else
          @season << @round
          @log.debug "SUCCESS: Round accepted" 
          @log.debug "Round: #{@round.map{|me| me}}" 
        end
        if(@season.count == number_of_rounds and 
           (check_pairs.uniq.count > 1 or 
            (check_pairs.uniq.count == 1 and 
             check_pairs.uniq.first != (@participants.length - 1))))
          @tries_per_season += 1
          @log.debug "FAIL: Season ended but not everyone met each other"
          @log.debug "Increase Try per Season - Total:#{@tries_per_season}"
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
  end
end

