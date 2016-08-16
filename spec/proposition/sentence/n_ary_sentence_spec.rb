require 'spec_helper'

module Proposition
  RSpec.describe NArySentence do
    let(:a) { AtomicSentence.new("A") }
    let(:b) { AtomicSentence.new("B") }
    let(:c) { AtomicSentence.new("C") }
    let(:d) { AtomicSentence.new("D") }
    let(:e) { AtomicSentence.new("E") }
    let(:f) { AtomicSentence.new("F") }
    let(:clause) { NArySentence.new(Logic::OR, a, b, c)}

    describe "Initialize" do
      let(:sentence) { NArySentence.new(Logic::AND, a, b, c, d, e, f) }

      it "should save the operands as a list" do
        expect(sentence.sentences).to eq([a,b,c,d,e,f])
      end
    end

    describe "is_clause?" do
      context "for a sentence with OR and atomic components" do
        it "should be true for " do
          expect(clause.is_clause?).to eq(true)
        end
      end

      context "for an atomic sentence in clause form" do
        let(:a_clause) { a.clause }
        it "should be a clause" do
          expect(a_clause.is_clause?).to eq(true)
        end
      end

      context "for a sentence with AND and atomic components" do
        let(:not_clause) { NArySentence.new(Logic::AND, a, b, c)}
        it "should be true for " do
          expect(not_clause.is_clause?).to eq(false)
        end
      end
      context "for a sentence with OR and a non-atomic component" do
        let(:not_atomic) { CompoundSentence.new(a, Logic::AND, b) }
        let(:not_clause) { NArySentence.new(Logic::AND, a, b, not_atomic) }
        it "should be true for " do
          expect(not_clause.is_clause?).to eq(false)
        end
      end

      context "resolve" do
        it "should add sentences which are not already present" do
          added = clause.resolve(d)
          expect(added.sentences.include?(d)).to be(true)
        end

        it "should remove contradictory sentences" do
          added = clause.resolve(a.negate)
          expect(added.sentences).not_to include(a)
          [b,c].each do |item|
            expect(added.sentences).to include(item)
          end
        end

        it "should return the sentence unchanged when given a redundant sentence to add" do
          expect(clause.resolve(a)).to eq(clause)
        end
      end
    end
  end
end
