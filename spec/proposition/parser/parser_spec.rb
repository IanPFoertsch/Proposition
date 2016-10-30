 require 'spec_helper'
module Proposition
  RSpec.describe Parser do
    let(:parser) { Parser.new(input) }

    shared_examples_for "accept string" do
      it "should accept the input string" do
        expect { parser.parse } .not_to raise_error
      end
    end

    describe "parse" do
      context "with a string of atoms" do
        let(:input) { "one two three" }
        include_examples "accept string"
      end

      context "binary sentence structure" do
        context "with parenthesis" do
          let(:input) { "(one and two)" }
          include_examples "accept string"
        end

        context "without parenthesis" do
          let(:input) { "one and two" }
          include_examples "accept string"
        end

        context "with a nested sentence" do
          let(:input) { "one and (two)" }
          include_examples "accept string"
        end

        context "with a two nested atoms in a binary sentence" do
          let(:input) { "(one) and (two)" }
          include_examples "accept string"
        end
      end

      context "n-ary sentence structure" do
        context "with simple non-nested atoms " do
          let(:input) { "one and two and three" }
          include_examples "accept string"
        end

        context "with simple non-nested atoms " do
          let(:input) { "one and two and three" }
          include_examples "accept string"
        end

        context "with simple non-nested atoms in parens" do
          let(:input) { "(one and two and three)" }
          include_examples "accept string"
        end

        context "with three nested sentences " do
          context "with identical operators" do
            let(:input) { "(one) and (two) and (three)" }
            include_examples "accept string"
          end

          context "with differing operators" do
            let(:input) { "(one) and (two) or (three)" }
            it "should not accept the input string" do
              expect { parser.parse } .to raise_error(Parser::ParseError)
            end
          end

          context "with nested n-ary sentences" do
            let(:input) { "((one and (two or four) and (three) and four) or (two) or three)" }
            include_examples "accept string"
          end
        end
      end
    end
  end
end
