require 'spec_helper'
require_relative '../../sentence_fixtures'

module Proposition
  RSpec.describe NArySentence do
    include_context "sentence fixtures"
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
