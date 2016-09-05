require 'spec_helper'

module Proposition
  RSpec.shared_context "sentence fixtures" do
    let(:a) { AtomicSentence.new("A") }
    let(:b) { AtomicSentence.new("B") }
    let(:c) { AtomicSentence.new("C") }
    let(:d) { AtomicSentence.new("D") }
    let(:f) { AtomicSentence.new("F") }

    let(:not_sentence) { CompoundSentence.new(a, Logic::NOT) }
    let (:compound_sentence) {CompoundSentence.new(a, Logic::AND, b)}
    let(:a_and_b) { CompoundSentence.new(a, Logic::AND, b) }
    let(:c_implication_d) { CompoundSentence.new(c, Logic::IMPLICATION, d) }

    let(:complex_compound) { CompoundSentence.new(a_and_b, Logic::XOR, c_implication_d) }
  end
end
