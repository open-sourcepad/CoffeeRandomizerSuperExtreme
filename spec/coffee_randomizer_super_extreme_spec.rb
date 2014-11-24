require 'spec_helper'

describe CoffeeRandomizerSuperExtreme do
  let(:template) { CoffeeRandomizerSuperExtreme::Template}

  context :regular do
    it 'should generate a template for 9 participants' do
      tg = template.new({member_count: 9})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 10 participants' do
      tg = template.new({member_count: 10})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 11 participants' do
      tg = template.new({member_count: 11})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 12 participants' do
      tg = template.new({member_count: 12})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 13 participants' do
      tg = template.new({member_count: 13})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 14 participants' do
      tg = template.new({member_count: 14})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it 'should generate a template for 15 participants' do
      tg = template.new({member_count: 15})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.check_pairs.uniq.count).to be == 1
    end

    it "should use main class for generating templates" do
      crse = CoffeeRandomizerSuperExtreme.new({member_count: 9})
      expect(crse.results).to_not be == false
      expect(crse.results).to_not be_empty
      expect(crse.results[9][:check_pairs].uniq.count).to be == 1
    end
  end

  context :use_case_2 do
    it 'should generate a template for 9 participants with 2 unable to meet together' do
      tg = template.new({member_count: 9, incompatible_count: 2})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.pair_manager.pairs[1].uniq.size).to be == 7
      expect(tg.pair_manager.pairs[2].uniq.size).to be == 7
      expect(tg.pair_manager.pairs[3].uniq.size).to be == 8
    end

    it 'should generate a template for 9 participants with 3 unable to meet together' do
      tg = template.new({member_count: 9, incompatible_count: 3})
      results = tg.generate
      expect(results).to_not be == false
      expect(results).to_not be_empty
      expect(tg.pair_manager.pairs[1].uniq.size).to be == 6
      expect(tg.pair_manager.pairs[2].uniq.size).to be == 6
      expect(tg.pair_manager.pairs[3].uniq.size).to be == 6
      expect(tg.pair_manager.pairs[4].uniq.size).to be == 8
    end

    it "should use main class for generating templates" do
      crse = CoffeeRandomizerSuperExtreme.new({member_count: 9, incompatible_count: 2})
      expect(crse.results).to_not be == false
      expect(crse.results).to_not be_empty
    end
  end
end

