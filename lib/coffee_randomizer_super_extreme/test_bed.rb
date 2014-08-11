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
        am = CoffeeRandomizerSuperExtreme::TemplateNormz.new(i)
        x = Time.now
        succeed = am.generate
        y = Time.now
        @results[i][:result] = succeed
        @results[i][:check_pairs] = am.check_pairs
        @results[i][:number_of_rounds] = am.number_of_rounds
        @results[i][:number_of_groups] = am.number_of_groups
        @results[i][:time] = (y - x) * 1000
        @log.info "========= Results for #{i} ========="
        @results[i].keys.each do |r|
          @log.info "#{r}: #{@results[i][r]}"
        end
      end
    end
  end
end
