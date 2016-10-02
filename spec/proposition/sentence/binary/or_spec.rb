require_relative "../../../../lib/proposition/sentence/binary/binary_sentence"
require_relative "../../../../lib/proposition/sentence/sentence"

require_relative "../../../../lib/proposition/sentence/atomic_sentence"
require_relative "../../../../lib/proposition/sentence/binary/or"
require_relative "../../../../lib/proposition/sentence/binary/and"
require_relative "../../../../lib/proposition/sentence/n_ary/clause"
require_relative "../../../../lib/proposition/sentence/n_ary/conjunctive_normal_form"

module Proposition
  RSpec.describe Or do

    let(:a) { AtomicSentence.new("a") }
    let(:b) { AtomicSentence.new("b") }
    let(:c) { AtomicSentence.new("c") }
    let(:d) { AtomicSentence.new("d") }

    let(:a_and_b) { And.new(a, b) }
    let(:c_and_d) { And.new(c, d) }

    let(:a_or_b) { Or.new(a, b) }
    let(:c_or_d) { Or.new(c, d) }

    describe "push_or_down" do
      context "with a deep right subsentence and an atomic left sentence" do
        let(:or_sentence) { Or.new(c, a_and_b) }
        it "should distribute the left subsentence into the right subsentence" do
          expect(a_and_b).to receive(:distribute_or).with(c).and_call_original
          or_sentence.push_or_down
        end
      end

      context "with a deep left subsentence and an atomic right subsentence" do
        let(:or_sentence) { Or.new(a_and_b, c) }
        it "should rotate the sentence and distribute the atomic component into the non-atomic component" do
          expect(or_sentence).to receive(:rotate).and_call_original
          expect(a_and_b).to receive(:distribute_or).with(c).and_call_original
          or_sentence.push_or_down
        end
      end

      context "with an OR sentence over an AND" do

        let(:or_sentence) { Or.new(a_and_b, c_and_d) }
        it "should distribute the left into the right" do
          expect(c_and_d).to receive(:distribute_or).with(a_and_b).and_call_original
          or_sentence.push_or_down
        end
      end

      context "with a sentence composed of only atomic or Or sentences" do
        let(:or_sentence) { Or.new(a_or_b, c_or_d) }

        it "should return the sentence unchanged" do
          expect(or_sentence.push_or_down).to eq(or_sentence)
        end
      end

      context "with a deeply nested AND" do
        let(:b_or) { Or.new(b, c_and_d) }
        let(:or_sentence) { Or.new(a, b_or) }

        let(:b_or_d) { Or.new(b, d) }
        let(:b_or_c) { Or.new(b, c) }
        let(:a_or_b_or_d) { Or.new(a, b_or_d) }
        let(:a_or_b_or_c) { Or.new(a, b_or_c) }
        let(:expectation) { And.new(a_or_b_or_c, a_or_b_or_d)}

        it "should recurse to the lowest level" do
          expect(or_sentence.push_or_down).to eq(expectation)
        end

        context "rotated" do
          let(:rotated_or) { or_sentence.rotate }

          it "should recurse to the lowest level" do
            expect(rotated_or.push_or_down).to eq(expectation)
          end
        end
      end
    end

    describe "to_disjunction" do
      context "with a single shallow sentence" do
        it "should return a clause instance" do
          expect(a_or_b.to_disjunction).to be_a(Disjunction)
        end
        it "should conjoin the clauses returned from the atomic sentences" do
          expect(a_or_b.to_disjunction.sentences).to include(a, b)
        end
      end
      context "with a multilevel or statement" do
        let(:multilevel_or) {Or.new(a_or_b, c_or_d)}

        it "should extract all of the atomic components to form a single clause" do
          clause = multilevel_or.to_disjunction
          expect(clause.sentences).to eq([a, b, c, d])
        end
      end
    end

    describe "distribute_not" do

    end

    describe "to_conjunction_of_disjunctions" do
      context "with a shallow or statement" do
        it "should return a CNF sentence" do
          expect(a_or_b.to_conjunction_of_disjunctions).to be_a(Conjunction)
        end

        it "should return CNF sentence containing the sentence's clause form" do
          sentences = a_or_b.to_conjunction_of_disjunctions.instance_variable_get(:@sentences)
          expect(sentences[0] == a_or_b.to_disjunction).to be(true)
        end
      end


    end
  end
end
