require 'spec_helper'

module Proposition
  RSpec.describe AtomicSentence do
    let(:a_symbol) { "A" }
    let(:atomic_sentence) { AtomicSentence.new(a_symbol) }
    let(:negated) { atomic_sentence.negate }

    describe ".initialize" do
      it "should initialize without errors with a string " do
        expect{ AtomicSentence.new("symbol", "NOT")}.not_to raise_error
      end

      [true, false].each do |bool|
        it "should initialize without errors with a boolean " do
          expect{ AtomicSentence.new(bool, "NOT")}.not_to raise_error
        end
      end

      it "should raise an error without a string or boolean" do
        expect{ AtomicSentence.new(4, "NOT")}.to raise_error(Exception)
      end
    end
    describe "is_unary?" do
      it "should be true" do
        expect(AtomicSentence.new(true).is_unary?).to eq(true)
      end
    end

    describe "is_atomic?" do
      it "should be true" do
        expect(AtomicSentence.new(true).is_atomic?).to eq(true)
      end
    end

    describe "deep_copy" do
      it "should not equal the original" do
        expect(atomic_sentence.deep_copy.equal?(atomic_sentence)).to be(false)
      end
    end

    describe "negate" do
      it "should return a new object" do
        expect(negated.equal?(atomic_sentence)).to be(false)
      end

      it "should copy the symbol" do
        expect(negated.symbol).to eq(atomic_sentence.symbol)
      end

      it "should reverse the operator if one is present" do
        expect(negated.operator).to eq(Logic::NOT)
      end

      context "with a boolean Atomic Sentence" do
        bools = [true, false]

        bools.each do |bool|
          it "should flip the truth value and leave the operator as nil" do
            original = AtomicSentence.new(bool)
            negated = AtomicSentence.new(!bool)
            expect(original.negate).to eq(negated)
            expect(original.negate.operator).to eq(nil)
          end
        end
      end
    end

    describe "in_text" do
      context "with only an operator" do
        it "should return the symbol" do
          expect(atomic_sentence.in_text).to eq(a_symbol)
        end
      end

      context "with an operator" do
        it "should include the operator and the symbol in the string" do
          expect(negated.in_text).to eq(Logic::NOT + " " + a_symbol)
        end
      end

      context "with a truth value" do
        bools = [true, false]

        bools.each do |bool|
          it "should return the truth value as a string" do
            expect(AtomicSentence.new(bool).in_text).to eq(bool.to_s)
          end
        end
      end
    end

    describe "push_not_down" do
      it "should return the sentence unchanged" do
        expect(atomic_sentence.push_not_down).to eq(atomic_sentence)
      end
    end

    describe "no_complex_operations" do
      it "should be true for any atomic_sentence" do
        expect(atomic_sentence.no_complex_operations?).to eq(true)
      end
    end

    describe "distribute" do
      let(:b) { AtomicSentence.new("B") }
      let(:expected) { "(B OR A)" }
      it "should return a new complex sentence of the form: (B OR A)" do
        expect(atomic_sentence.distribute(b, Logic::OR).in_text).to eq(expected)
      end
    end

    describe "clause" do
      it "should return a single-element NArySentence" do
        expect(atomic_sentence.to_clause).to be_a(NArySentence)
      end

      it "should contain a copy of the atomic literal" do
        expect(atomic_sentence.to_clause.sentences[0]).to eq(atomic_sentence)
      end
    end

    describe "contains_operator?" do
      let(:not_sentence) { atomic_sentence.negate }
      it "should be false for a sentence without an operator" do
        expect(atomic_sentence.contains_operator?(Logic::NOT)).to be false
      end

      it "should be false for any operator other than NOT" do
        expect(not_sentence.contains_operator?(Logic::AND)).to be false
      end

      it "should be true for a negated sentence and contains NOT query" do
        expect(not_sentence.contains_operator?(Logic::NOT)).to be true
      end
    end
  end
end
