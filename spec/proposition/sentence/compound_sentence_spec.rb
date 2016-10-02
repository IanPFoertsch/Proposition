require 'spec_helper'
require_relative '../sentence_fixtures'

module Proposition
  RSpec.describe CompoundSentence do
    include_context "sentence fixtures"

    describe "is_unary?" do
      it "should be true for a unary Sentence" do
        expect(not_sentence.is_unary?).to eq(true)
      end

      it "should be false for a non_unary sentence" do
        expect(compound_sentence.is_unary?).to be(false)
      end
    end

    describe "is_atomic?" do
      it "should be true" do
        expect(compound_sentence.is_atomic?).to eq(false)
      end
    end

    describe "deep_copy" do
      it "should not equal the original" do
        expect(compound_sentence.deep_copy.equal?(compound_sentence)).to be(false)
      end
    end

    describe "distribute_not" do

      describe "Associative operators" do
        normal_operator_map = {
          Logic::AND => Logic::OR,
          Logic::OR => Logic::AND,
          Logic::XOR => Logic::BICONDITIONAL,
          Logic::BICONDITIONAL => Logic::XOR
        }

        normal_operator_map.each do |operator, inverted_op|
          it "should distribute_not into a CompoundSentence, altering the operator" do
            original = CompoundSentence.new(a, operator, b)
            inverted = original.distribute_not
            expect(inverted.operator).to eq(inverted_op)
            expect(inverted.left).to eq(a.negate)
            expect(inverted.right).to eq(b.negate)
          end
        end
      end

      describe "Non-associative operators" do
        let(:implication_sentence) { CompoundSentence.new(a, Logic::IMPLICATION, b) }

        it "should negate an IMPLICATION sentence correctly" do
          inverted = implication_sentence.distribute_not

          expect(inverted.operator).to eq(Logic::AND)
          expect(inverted.left).to eq(a)
          expect(inverted.right).to eq(b.negate)
        end
      end
    end

    describe "in_text" do
      let(:a_and_b_text) { "(A AND B)" }
      let(:c_implication_d_text) { "(C IMPLICATION D)" }
      let(:compound_text) { "(" + a_and_b_text + " XOR " + c_implication_d_text + ")"}

      it "should operate on a shallow compound sentence" do
        expect(a_and_b.in_text).to eq(a_and_b_text)
      end

      it "should recursively convert sub_sentences to text" do
        expect(complex_compound.in_text).to eq(compound_text)
      end
    end

    describe "push_not_down" do
      let(:subject) { CompoundSentence.new(a, Logic::AND, b)}
      it "should recursively push not down" do
        expect(a).to receive(:push_not_down)
        expect(b).to receive(:push_not_down)
        subject.push_not_down
      end

      it "should not change the operator" do
        expect(subject.push_not_down.operator).to eq(subject.operator)
      end
    end

    describe "no_complex_operations?" do
      operator_map = {
        Logic::AND => true,
        Logic::OR => true,
        Logic::XOR => false,
        Logic::BICONDITIONAL => false,
        Logic::IMPLICATION => false
      }

      operator_map.each do |operator, expected|


        it "should return #{expected} for a shallow sentence with op #{operator} " do
          original = CompoundSentence.new(a, operator, b)
          expect(original.no_complex_operations?).to eq(expected)
        end

        if expected
          it "should recurse into each sub_sentence" do
            original = CompoundSentence.new(a, operator, b)
            expect(a).to receive(:no_complex_operations?).and_call_original
            expect(b).to receive(:no_complex_operations?).and_call_original
            expect(original.no_complex_operations?).to eq(expected)
          end
        else
          it "should short-circuit evaluation and return false" do
            original = CompoundSentence.new(a, operator, b)
            expect(a).not_to receive(:no_complex_operations?).and_call_original
            expect(b).not_to receive(:no_complex_operations?).and_call_original
            expect(original.no_complex_operations?).to eq(expected)
          end
        end
      end
     end

    describe "eliminate_binary_operator" do
      let(:implication_sentence) do
        CompoundSentence.new(a, Logic::IMPLICATION, b)
      end
      let(:negated_a) { a.negate  }

      context "IMPLICATION" do
        it "should eliminate implication" do
          eliminated = implication_sentence.eliminate_operator(Logic::IMPLICATION)
          expect(eliminated.operator).to eq(Logic::OR)
          expect(eliminated.left).to eq(negated_a)
          expect(eliminated.right).to eq(b)
        end
      end

      context "XOR" do
        let(:xor_sentence) { CompoundSentence.new(a, Logic::XOR, b) }
        let(:not_a_and_b) { NegatedSentence.new(a_and_b)}
        let(:expectation) { CompoundSentence.new(a_or_b, Logic::AND, not_a_and_b)}
        it "should eliminate XOR" do
          eliminated = xor_sentence.eliminate_operator(Logic::XOR)
          expect(eliminated).to eq(expectation)
        end
      end

      context "BICONDITIONAL" do
        let(:biconditional_sentence) do
          CompoundSentence.new(a, Logic::BICONDITIONAL, b)
        end
        let(:not_a_or_b) { NegatedSentence.new(a_or_b) }
        let(:expectation) { CompoundSentence.new(a_and_b, Logic::OR, not_a_or_b) }

        it "should eliminate BICONDITIONAL" do
          eliminated = biconditional_sentence.eliminate_operator(Logic::BICONDITIONAL)
          expect(eliminated).to eq(expectation)
        end
      end

      context "with a non-matching operator and sentence" do
        let(:operator) { Logic::XOR }
        it "should not perform any action on the original sentence" do
          expect(a).to receive(:eliminate_operator).with(operator).and_call_original
          expect(b).to receive(:eliminate_operator).with(operator).and_call_original
          eliminated = implication_sentence.eliminate_operator(operator)
          expect(eliminated).to eq(implication_sentence)
          expect(eliminated).not_to equal(implication_sentence)
        end
      end
    end

    context "distribute" do
      context "OR" do
        let(:operator) { Logic::OR }
        context "simple shallow, non-unary sentence" do
          let(:expected_text) { "((C OR A) AND (C OR B))" }
          it "should distribute 'c OR' into 'a AND b''" do
            expect(a_and_b.distribute(c, operator).in_text).to eq(expected_text)
          end
        end
      end
    end

    context "push_or_down" do
      let(:c_and_d) { CompoundSentence.new(c, Logic::AND, d) }
      let(:complex) { CompoundSentence.new(a_and_b, Logic::AND, c_and_d) }
      let(:f_or_complex) { CompoundSentence.new(f, Logic::OR, complex) }
      let(:expected_text) { "(((F OR A) AND (F OR B)) AND ((F OR C) AND (F OR D)))" }

      context "with a complex compound sentence" do
        it "should push OR down" do
          expect(f_or_complex.push_or_down.in_text).to eq(expected_text)
        end
      end

      context "for a simple compound" do
        let(:expected) { "(A AND B)" }
        it "should return the sentence unchanged" do
          expect(a_and_b.push_or_down.in_text).to eq(expected)
        end
      end

      context "for non-atomic left and right sub sentences" do
        let(:complex_or) { CompoundSentence.new(a_and_b, Logic::OR, c_and_d) }
        let(:expected) { "(((C OR A) AND (C OR B)) AND ((D OR A) AND (D OR B)))" }
        it "should not recurse infinitely" do
          expect(complex_or.push_or_down.in_text).to eq(expected)
        end
      end

      context "for a left or right hand compound sentences" do
        let(:left_hand_compound) { CompoundSentence.new(a_and_b, Logic::OR, f) }
        let(:right_hand_compound) { CompoundSentence.new(f, Logic::OR, a_and_b) }
        let(:expected) { "((F OR A) AND (F OR B))" }

        it "should rotate and distribute" do
          expect(left_hand_compound.push_or_down.in_text).to eq(expected)
        end


        it "should rotate and distribute" do
          expect(right_hand_compound.push_or_down.in_text).to eq(expected)
        end


        context "a sentence with the operator in both subsentences" do
          let(:two_or_subsentences) { CompoundSentence.new(a_or_b, Logic::OR, c_or_d) }

          let(:expected) { "((A OR B) OR (C OR D))" }

          it "should recurse to the subsentences but leave them unchanged" do
            expect(two_or_subsentences.push_or_down.in_text).to eq(expected)
          end
        end
      end
    end

    describe "contains_operator" do
      let(:c_and_d) { CompoundSentence.new(c, Logic::AND, d) }
      let(:a_or_c_and_d) { CompoundSentence.new(a, Logic::OR, c_and_d) }

      it "should check the subsentences" do
        expect(a_or_c_and_d.contains_operator?(Logic::AND)).to eq(true)
      end

      it "should check the first level of nesting" do
        expect(a_or_c_and_d.contains_operator?(Logic::OR)).to eq(true)
      end

      it "should return false for an operator which is absent" do
        expect(a_or_c_and_d.contains_operator?(Logic::XOR)).to eq(false)
      end
    end

    context "to_disjunction" do
      context "when a sentence contains an AND operator" do

        it "should throw an exception" do
          expect{ a_and_b.to_disjunction }.to raise_error("to_disjunction called on sentence containing operator other than OR")
        end
      end

      context "with an XOR operator" do
        let(:a_xor_b) { CompoundSentence.new(a, Logic::XOR, b) }

        it "should throw an exception" do
          expect{ a_xor_b.to_disjunction }.to raise_error("to_disjunction called on sentence containing operator other than OR")
        end
      end

      context "without complex operators or AND" do
        let(:subject) { CompoundSentence.new(a_or_b, Logic::OR, c_or_d) }
        let(:expected) { "(A OR B OR C OR D)" }

        it "should contain the components as literals" do
          expect(subject.to_disjunction.in_text).to eq(expected)
        end
      end
    end
  end
end
