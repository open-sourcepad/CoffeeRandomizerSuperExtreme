require 'spec_helper'

describe CoffeeRandomizerSuperExtreme do
  let(:template_generator) { CoffeeRandomizerSuperExtreme::TemplateGenerator}

  it 'should generate a template for 9 participants' do
    tg = template_generator.new(9)
    results = tg.generate
    expect(results).to_not be == false
    expect(tg.check_pairs.uniq.count).to be == 1
  end
end
