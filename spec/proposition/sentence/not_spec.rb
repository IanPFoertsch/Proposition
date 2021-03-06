require 'spec_helper'

module Proposition
  RSpec.describe Not do
    let(:a) { AtomicSentence.new("a") }
    let(:b) { AtomicSentence.new("b") }
    let(:a_or_b) { Or.new(a, b) }
    let(:negated_sentence) { Not.new(a_or_b) }
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
      let(:c) { AtomicSentence.new("c") }
      let(:pushed) { double("Pushed Not Down") }

      it "should push not down, then distribute on the result" do
        expect(negated_sentence).to receive(:push_not_down).and_return(pushed)
        expect(pushed).to receive(:distribute_or).with(c)
        negated_sentence.distribute_or(c)
      end
    end

    describe "distribute_and" do
      let(:c) { AtomicSentence.new("c") }
      let(:pushed) { double("Pushed Not Down") }

      it "should push not down, then distribute on the result" do
        expect(negated_sentence).to receive(:push_not_down).and_return(pushed)
        expect(pushed).to receive(:distribute_and).with(c)
        negated_sentence.distribute_and(c)
      end
    end
  end
end
