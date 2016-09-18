require 'spec_helper'

module Proposition
  RSpec.describe Evaluator do
    let(:a_sentence) { AtomicSentence.new("A") }
    let(:b_sentence) { AtomicSentence.new("B")}
    let(:compound) { CompoundSentence.new(nil, nil)}
    let(:evaluator) { Proposition::Evaluator }
    let(:true_sentence) { AtomicSentence.new(true) }
    let(:false_sentence) { AtomicSentence.new(false) }

    describe "is_atomic?" do

      it "should be true with an atomic sentence" do
        expect(evaluator.is_atomic?(a_sentence)).to eq(true)
      end

      it "should be false with a compound sentence" do
        expect(evaluator.is_atomic?(compound)).to eq(false)
      end
    end

    describe "is_compound?" do
      it "should be true with an atomic sentence" do
        expect(evaluator.is_compound?(a_sentence)).to eq(false)
      end

      it "should be false with a compound sentence" do
        expect(evaluator.is_compound?(compound)).to eq(true)
      end
    end

    describe "evaluate" do
      let(:true_sentence) { AtomicSentence.new(true) }
      let(:model) { {"A" => true} }
      context "given a model" do
        context "given an atomic sentence" do
          context "with a boolean value" do
            it "should return the value of the boolean" do
              expect(evaluator.evaluate(true_sentence, model)).to eq(true)
            end
          end
          context "with a symbol" do
            let(:a_sentence) { AtomicSentence.new("A")}
            it "should return the value of the symobl in the model" do
              expect(evaluator.evaluate(a_sentence, model)).to eq(true)
            end
          end
        end
        context "given a negated sentence" do
          let(:negated) { NegatedSentence.new(true_sentence)}

          it "should negate a unary sentence with a false operator" do
            expect(evaluator.evaluate(negated, model)).to eq(false)
          end
        end

        context "given a non unary compound sentence" do
          it "should apply the" do

          end
        end
      end
    end

    describe "apply_operatore" do
      shared_examples_for "a binary boolean operation" do |truth_table, operator, model = {}|
        truth_table.each do |operands, result|
          it "should evaluate #{operands[0]} #{operator} #{operands[1]} as #{result}}" do
            left = AtomicSentence.new(operands[0])
            right = AtomicSentence.new(operands[1])
            expect(evaluator.apply_operator(model, left, operator, right))
              .to eq(result)
          end
        end
      end

      context "XOR" do
        truth_table = {
          [false, false] => false,
          [false, true]  => true,
          [true, false] => true,
          [true, true] => false
        }
        it_should_behave_like "a binary boolean operation", truth_table, Logic::XOR
      end

      context "AND" do
        truth_table = {
          [false, false] => false,
          [false, true]  => false,
          [true, false] => false,
          [true, true] => true
        }
        it_should_behave_like "a binary boolean operation", truth_table, Logic::AND
      end

      context "OR" do
        truth_table = {
          [false, false] => false,
          [false, true]  => true,
          [true, false] => true,
          [true, true] => true
        }
        it_should_behave_like "a binary boolean operation", truth_table, Logic::OR
      end

      context "IMPLICATION" do
        truth_table = {
          [false, false] => true,
          [false, true]  => true,
          [true, false] => false,
          [true, true] => true
        }
        it_should_behave_like "a binary boolean operation", truth_table, Logic::IMPLICATION
      end

      context "BICONDITIONAL" do
        truth_table = {
          [false, false] => true,
          [false, true]  => false,
          [true, false] => false,
          [true, true] => true
        }
        it_should_behave_like "a binary boolean operation", truth_table, Logic::BICONDITIONAL
      end
    end
  end
end
