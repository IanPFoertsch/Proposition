require_relative "../../../../lib/proposition/sentence/binary/binary_sentence"
require_relative "../../../../lib/proposition/sentence/sentence"
require_relative "../../../../lib/proposition/sentence/atomic_sentence"
require_relative "../../../../lib/proposition/sentence/binary/or"
require_relative "../../../../lib/proposition/sentence/binary/and"

require_relative "../../../../lib/proposition/sentence/n_ary/disjunction"

module Proposition
  RSpec.describe Disjunction do
    describe "operator" do
      it "should return OR" do
        expect(Disjunction.new([]).operator).to eq("OR")
      end
    end
  end
end
