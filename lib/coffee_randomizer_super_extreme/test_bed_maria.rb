module CoffeeRandomizerSuperExtreme
  class TestBedMaria
    attr_accessor :results

    def initialize
      @log = ::Logger.new("log/results.log")
    end

    def start(range)
      range.each do |i|
        @log.info "========= Results for #{i} ========="
        CoffeeRandomizerSuperExtreme::TemplateMaria.new(i).generate_groups
      end
    end
  end
end

