 require 'spec_helper'
module Proposition
  RSpec.describe Parser do
    describe "build_model" do
      let(:content) { ["A\nB","C"] }
      let(:symbols) { ["A","B","C"] }

      it "should build a model composed of correct symbols" do

        model = Parser.build_model(content)

        symbols.each do |symbol|
          expect(model[symbol]).to eq(true)
        end
      end
    end
  end
end
