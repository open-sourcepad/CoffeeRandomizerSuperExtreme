require 'spec_helper'

describe CoffeeRandomizerSuperExtreme do
  let(:template) { CoffeeRandomizerSuperExtreme::Template}
  let(:testbed) { CoffeeRandomizerSuperExtreme::TestBed}

  context :normz do
    it 'should generate a template for 9 participants' do
      tg = template.new(9)
      results = tg.generate
      expect(results).to_not be == false
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 10 participants' do
      tg = template.new(10)
      results = tg.generate
      expect(results).to_not be == false
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 11 participants' do
      tg = template.new(11)
      results = tg.generate
      expect(results).to_not be == false
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it "should use test bed for generating templates" do
      tb = testbed.new
      tb.start(9..9)
      expect(tb.results).to_not be == false
      expect(tb.results[9][:check_pairs].uniq.count).to be == 1
    end
  end
end

