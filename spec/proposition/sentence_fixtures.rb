require 'spec_helper'

module Proposition
  RSpec.shared_context "sentence fixtures" do
    let(:a) { AtomicSentence.new("A") }
    let(:b) { AtomicSentence.new("B") }
    let(:c) { AtomicSentence.new("C") }
    let(:d) { AtomicSentence.new("D") }
    let(:e) { AtomicSentence.new("E") }
    let(:f) { AtomicSentence.new("F") }
    let(:g) { AtomicSentence.new("G") }

    let(:a_or_b) { Or.new(a, b) }
    let(:c_or_d) { Or.new(c, d) }
    let(:a_and_b) { And.new(a, b) }
    let(:c_and_d) { And.new(c, d) }

    let(:not_sentence) { NegatedSentence.new(a) }
  end
end
