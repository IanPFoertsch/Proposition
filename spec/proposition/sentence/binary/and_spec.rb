require_relative "../../../../lib/proposition/sentence/binary/binary_sentence"
require_relative "../../../../lib/proposition/sentence/sentence"

require_relative "../../../../lib/proposition/sentence/atomic_sentence"
require_relative "../../../../lib/proposition/sentence/binary/or"
require_relative "../../../../lib/proposition/sentence/binary/and"

module Proposition
  RSpec.describe And do

    let(:a) { AtomicSentence.new("a") }
    let(:b) { AtomicSentence.new("b") }
    let(:c) { AtomicSentence.new("c") }
    let(:d) { AtomicSentence.new("d") }

    let(:a_or_b) { Or.new(a, b) }
    let(:c_or_d) { Or.new(c, d) }

    let(:a_and_b) { And.new(a, b) }
    let(:c_and_d) { And.new(c, d) }

    describe "push_and_down" do
      context "with a deep right subsentence and an atomic left sentence" do
        let(:and_sentence) { And.new(c, a_or_b) }
        it "should distribute the left subsentence into the right subsentence" do
          expect(a_or_b).to receive(:distribute_and).with(c).and_call_original
          and_sentence.push_and_down
        end
      end

      context "with a deep left subsentence and an atomic right subsentence" do
        let(:and_sentence) { And.new(a_or_b, c) }
        it "should rotate the sentence and distribute the atomic component into the non-atomic component" do
          expect(and_sentence).to receive(:rotate).and_call_original
          expect(a_or_b).to receive(:distribute_and).with(c).and_call_original
          and_sentence.push_and_down
        end
      end

      context "with an AND sentence over an OR" do
        let(:and_sentence) { And.new(a_or_b, c_or_d) }
        it "should distribute the left into the right" do
          expect(c_or_d).to receive(:distribute_and).with(a_or_b).and_call_original
          and_sentence.push_and_down
        end
      end

      context "with a sentence composed of only atomic or And sentences" do
        let(:and_sentence) { And.new(a_and_b, c_and_d) }

        it "should return the sentence unchanged" do
          expect(and_sentence.push_and_down).to eq(and_sentence)
        end
      end

      context "with a deeply nested AND" do
        let(:b_and) { And.new(b, c_or_d) }
        let(:and_sentence) { And.new(a, b_and) }

        let(:b_and_d) { And.new(b, d) }
        let(:b_and_c) { And.new(b, c) }
        let(:a_and_b_and_d) { And.new(a, b_and_d) }
        let(:a_and_b_and_c) { And.new(a, b_and_c) }
        let(:expectation) { Or.new(a_and_b_and_c, a_and_b_and_d)}

        it "should recurse to the lowest level" do
          expect(and_sentence.push_and_down).to eq(expectation)
        end

        context "rotated" do
          let(:rotated_and) { and_sentence.rotate }

          it "should recurse to the lowest level" do
            expect(rotated_and.push_and_down).to eq(expectation)
          end
        end
      end
    end
  end
end
