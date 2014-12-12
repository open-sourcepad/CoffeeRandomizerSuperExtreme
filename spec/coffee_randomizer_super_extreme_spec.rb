require 'spec_helper'

describe CoffeeRandomizerSuperExtreme do
  let(:template) { CoffeeRandomizerSuperExtreme::Template}

  context :regular do
    it 'should generate a template for 9 participants' do
      tg = template.new({members: (1..9).to_a})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 10 participants' do
      tg = template.new({members: (1..10).to_a})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 11 participants' do
      tg = template.new({members: (1..11).to_a})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 12 participants' do
      tg = template.new({members: (1..12).to_a})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 13 participants' do
      tg = template.new({members: (1..13).to_a})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 14 participants' do
      tg = template.new({members: (1..14).to_a})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 15 participants' do
      tg = template.new({members: (1..15).to_a})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it "should use main class for generating templates" do
      crse = CoffeeRandomizerSuperExtreme.new({members: (1..9).to_a})
      expect(crse.results).to_not be == false
      expect(crse.results).to_not be_empty
      expect(crse.results[9][:check_pairs].uniq.count).to be == 1
    end
  end

  context :use_case_2 do
    it 'should generate a template for 9 participants with 2 unable to meet together' do
      tg = template.new({members: (1..9).to_a, incompatibles: {1 => [2], 2 => [1]}})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.pair_manager.pairs[1].uniq.size).to be == 7
      expect(tg.pair_manager.pairs[2].uniq.size).to be == 7
      expect(tg.pair_manager.pairs[3].uniq.size).to be == 8
    end

    it 'should generate a template for 9 participants with 3 unable to meet together' do
      tg = template.new({members: (1..9).to_a, incompatibles: {1 => [3], 2 => [3], 3 => [1,2]}})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.pair_manager.pairs[1].uniq.size).to be == 7
      expect(tg.pair_manager.pairs[2].uniq.size).to be == 7
      expect(tg.pair_manager.pairs[3].uniq.size).to be == 6
    end

    it "should use main class for generating templates" do
      crse = CoffeeRandomizerSuperExtreme.new({members: (1..9).to_a, incompatibles: {1 => [2], 2 => [1]}})
      expect(crse.results).to_not be == false
      expect(crse.results).to_not be_empty
    end
  end
end
