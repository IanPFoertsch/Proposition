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

    describe "initialize" do
      shared_examples_for "alphabetize sentences" do
        before do
          allow(input).to receive(:operator).and_return("OP")
          allow(expected).to receive(:operator).and_return("OP")
        end

        it "should re-order the input sentences to be sorted" do
          expect(input.in_text).to eq(expected.in_text)
        end
      end

      context "with a simple input sentence" do
        let(:input) { NArySentence.new([c, b, a])}
        let(:expected) { NArySentence.new([a, b, c])}

        include_examples "alphabetize sentences"
      end

      context "with a nested sentence" do
        let(:input) { NArySentence.new([c, e_or_f, a])}
        let(:expected) { NArySentence.new([a, c, e_or_f])}

        include_examples "alphabetize sentences"
      end
    end

    describe "#hash" do
      let(:input) { n_ary_a_b_c }

      before do
        allow(input).to receive(:operator).and_return("OP")
      end
      
      it "should return the hash value of the string representation" do
        expect(input.hash).to eq(n_ary_a_b_c.in_text.hash)
      end
    end
  end
end
