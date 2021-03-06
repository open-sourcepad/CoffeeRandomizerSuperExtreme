require 'spec_helper'

describe CoffeeRandomizerSuperExtreme do
  let(:template_normz) { CoffeeRandomizerSuperExtreme::TemplateNormz}
  let(:testbed) { CoffeeRandomizerSuperExtreme::TestBed}
  let(:generator) { CoffeeRandomizerSuperExtreme::TemplateMaria }

  context :normz do
    it 'should generate a template for 9 participants' do
      tg = template_normz.new(9)
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

  context :maria do
    it "generates a template for 9 participants" do
      expect(generator.new(9).generate_groups).to eq true
    end
  end
end

