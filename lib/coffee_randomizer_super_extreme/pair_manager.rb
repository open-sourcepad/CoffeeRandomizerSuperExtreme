module CoffeeRandomizerSuperExtreme
  class PairManager
    def initialize(participants)
      @pairs = {}
      @participants = participants
    end

    def rebuild
      @participants.each do |p|
        @pairs[p] = []
      end
    end

    def check_pairs
      @pairs.map{|key, val| val.uniq.count}
    end

    def get_pair_count(participant, target)
      @pairs[participant].select{|me| me == target}.count
    end

    def rebuild_pair_manager(season)
      @participants.each do |p|
        @pairs[p] = []
        season.each do |round|
          round.each do |group|
            group.each do |participant|
              @pairs[p] << participant if p != participant and group.include?(p)
            end
          end
        end
      end
    end

    def add_group_to_pairs(group, participant)
      group.each do |possible_pair|
        @pairs[participant] << possible_pair
        @pairs[possible_pair] << participant
      end
    end
  end
end
