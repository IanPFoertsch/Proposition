require 'spec_helper'

module Proposition
  RSpec.describe Lexer do
    describe "tokenize" do
      let(:sample_string) { "A\nB;E\nC\nD" }
      let(:expected) {["A","B","E","C","D"] }

      it "should tokenize" do
        #expected = ["A","B","E","C","D"]
        splitters = ["\n", ";"]
        results = Lexer.tokenize(sample_string, splitters)
        expect(results).to eq(expected)
      end

      shared_examples_for "correct_tokenization" do |input, splitters, expected|
        it "should correctly tokenize" do
          expect(Lexer.tokenize(input, splitters)).to eq(expected)
        end
      end

      context "with a single string" do
        single = "A\nB\nC"
        splitter = "\n"
        expected = ["A","B","C"]

        it_should_behave_like "correct_tokenization", single, splitter, expected

        context "with two splitters" do
          splitter = ["\n", ";"]

          it_should_behave_like "correct_tokenization", single, splitter, expected
        end
      end
    end

    describe "recurse_over_array" do
      let(:content) { ["A\nB","C"] }
      let(:expected) { ["A","B","C"] }

      it "should recurse and return the expected result" do
        expect(Lexer.recurse_over_array(content, "\n")).to eq(expected)
      end
    end
  end
end
