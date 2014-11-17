require 'spec_helper'

describe CoffeeRandomizerSuperExtreme do
  let(:template) { CoffeeRandomizerSuperExtreme::Template}

  context :normz do
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
end

