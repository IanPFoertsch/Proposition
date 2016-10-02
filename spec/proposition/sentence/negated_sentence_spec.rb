require 'spec_helper'
require_relative '../sentence_fixtures'

module Proposition
  RSpec.describe NegatedSentence do
    include_context "sentence fixtures"
    let(:negated_sentence) { NegatedSentence.new(a_or_b) }
    describe "in_text" do

      it "should return the sentence's text value wrapped in 'NOT ...'" do
        expect(negated_sentence.in_text).to eq("NOT #{a_or_b.in_text}")
      end
    end

    describe "negate" do
      it "should return a copy of the wrapped sentence" do
        expect(negated_sentence.negate).to eq(a_or_b)
      end
    end

    describe "push not down" do
      it "should unpack the wrapped sentence and distribute_not on it" do
        expect(negated_sentence.push_not_down)
          .to eq(a_or_b.distribute_not.push_not_down)
      end
    end

    describe "distribute_or" do
      
    end
  end
end
