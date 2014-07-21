require 'spec_helper'

describe CoffeeRandomizerSuperExtreme do
  let(:template_generator) { CoffeeRandomizerSuperExtreme::TemplateGenerator}
  let(:testbed) { CoffeeRandomizerSuperExtreme::TestBed}

  it 'should generate a template for 9 participants' do
    tg = template_generator.new(9)
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
