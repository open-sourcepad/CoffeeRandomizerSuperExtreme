module CoffeeRandomizerSuperExtreme
  class TestBed
    attr_accessor :results

    def initialize
      @results = {}
      @log = ::Logger.new("log/results.log")
    end

    def start(range)
      range.each do |i|
        @results[i] = {}
        am = CoffeeRandomizerSuperExtreme::TemplateGenerator.new(i)
        x = Time.now
        succeed = am.generate
        y = Time.now
        @results[i][:result] = succeed
        @results[i][:check_pairs] = am.check_pairs
        @results[i][:number_of_rounds] = am.number_of_rounds
        @results[i][:number_of_groups] = am.number_of_groups
        @results[i][:check_duplicates] = am.check_duplicates
        @results[i][:time] = (y - x) * 1000
        @results[i][:tries_per_season] = am.tries_per_season
        @log.info "========= Results for #{i} ========="
        @results[i].keys.reject{|me| [:check_pairs, :check_duplicates].include?(me)}.each do |r|
          @log.info "#{r}: #{@results[i][r]}"
        end
      end
    end
  end
end
