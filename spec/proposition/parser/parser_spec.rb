require 'spec_helper'

module Proposition
  RSpec.describe Parser do
    let(:parser) { Parser.new(input) }

    shared_examples_for "accept string" do
      it "should accept the input string" do
        expect { parser.parse } .not_to raise_error
      end
    end

    shared_examples_for "reject string" do
      it "should reject the input string" do
        expect { parser.parse } .to raise_error(Parser::ParseError)
      end
    end

    shared_examples_for "IRTree type" do
      it "should return an IR Node" do
        expect(parser.parse).to be_a(IRTree)
      end
    end


    describe "parse" do
      context "with a single atom" do
        let(:input) { "raining" }
        include_examples "IRTree type"

        it "should return shallow IR node" do
          tree = parser.parse
          expect(tree.leaf_node?).to be(true)
        end
      end
      context "with a string of atoms" do
        #TODO: Update this to require some sort of delimiter
        #for a string of atoms
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
          include_examples "IRTree type"

          context "tree structure" do
            let(:tree) { parser.parse }
            it "should return an IRTree with an operator" do
              expect(tree.operator.string).to eq("and")
            end

            it "should return a binary IRTree" do
              expect(tree.binary?).to be(true)
            end

            it "should have 'one' and 'two as children'" do
              puts tree.left.atom.string
              expect(tree.left.atom).to eq(Atom.new("one"))
              expect(tree.operator).to eq(Operator.new("and"))
              expect(tree.right.atom).to eq(Atom.new("two"))
            end
          end
        end

        context "with a nested sentence" do
          let(:input) { "one and (two)" }
          include_examples "accept string"
        end

        context "with a two nested atoms in a binary sentence" do
          let(:input) { "(one) and (two)" }
          include_examples "accept string"
        end

        context "with an atom, followed by an optional tail" do
          let(:intput) { "one and two"}
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
