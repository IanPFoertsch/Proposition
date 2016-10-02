require_relative "../../../../lib/proposition/sentence/binary/binary_sentence"
require_relative "../../../../lib/proposition/sentence/sentence"
require_relative "../../../../lib/proposition/sentence/atomic_sentence"
require_relative "../../../../lib/proposition/sentence/binary/or"
require_relative "../../../../lib/proposition/sentence/binary/and"

require_relative "../../../../lib/proposition/sentence/n_ary/n_ary_sentence"

module Proposition
  RSpec.describe NArySentence do
    let(:a) { AtomicSentence.new("a") }
    let(:b) { AtomicSentence.new("b") }
    let(:c) { AtomicSentence.new("c") }
    let(:d) { AtomicSentence.new("d") }

    describe "conjoin" do

      let(:n_ary_one) { NArySentence.new([a, b]) }
      let(:n_ary_two) { NArySentence.new([c, d]) }

      it "should return a new sentence" do
        expect(n_ary_one.conjoin(n_ary_two)).to be_instance_of(NArySentence)
      end

      it "should contain all of the subsentences of each component" do
        conjoined_sentences = n_ary_one.conjoin(n_ary_two).sentences
        expect(conjoined_sentences.length).to eq(4)
        [a,b,c,d].each do |atomic_sentence|
          expect(conjoined_sentences.include?(atomic_sentence)).to be(true)
        end
      end
    end
  end
end
