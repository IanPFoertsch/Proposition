require 'spec_helper'
module Proposition
  RSpec.describe Parser do
    let(:parser) { Parser.new(input) }
    let(:tree) { parser.parse_sentence }

    shared_examples_for "accept string" do
      it "should accept the input string" do
        expect { parser.parse_sentence } .not_to raise_error
      end
    end

    shared_examples_for "reject string" do
      it "should reject the input string" do
        expect { parser.parse_sentence } .to raise_error(Parser::ParseError)
      end
    end

    shared_examples_for "IRTree type" do
      it "should return an IR Node" do
        expect(parser.parse_sentence).to be_a(IRTree)
      end
    end

    shared_examples_for "IRTree operator token" do |token_string|
      it "should have an '#{token_string}' operator" do
        expect(tree.operator.string).to eq(token_string)
      end
    end

    describe "parse_sentence" do
      context "with a single atom" do
        let(:input) { "raining" }
        include_examples "IRTree type"

        it "should return shallow IR node" do
          tree = parser.parse_sentence
          expect(tree.leaf_node?).to be(true)
        end
      end

      context "with a unary sentence structure" do
        let(:input) { "not raining" }
        include_examples "accept string"
        include_examples "IRTree type"
        include_examples "IRTree operator token", "not"

        context "with a tail" do
          let(:input) { "not raining or snowing" }
          include_examples "accept string"
          include_examples "IRTree type"
          include_examples "IRTree operator token", "or"
        end

        context "within a n-ary sentence structure" do
          let(:input) { "snowing or not raining or misting" }
          include_examples "accept string"
          include_examples "IRTree type"
          include_examples "IRTree operator token", "or"
        end

        context "with a nested string of unary operators" do
          let(:input) { "not not not raining" }
          include_examples "accept string"
          include_examples "IRTree operator token", "not"

          it "should wrap each sub-sentence in a unary operator" do
            sub_sentence = tree
            2.times do
              sub_sentence = sub_sentence.children.first
              expect(sub_sentence.operator).to be_a(UnaryOperator)
            end
          end

          context "within an n-ary sentence structure" do
            let(:input) { "snowing or not not raining or misting" }
            include_examples "accept string"
            include_examples "IRTree type"
            include_examples "IRTree operator token", "or"
          end

          context "with an invalid sequence of unary operators" do
            let(:input) { "snowing or not raining not misting" }
            include_examples "reject string"
          end
        end
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
            it "should return an IRTree with an operator" do
              expect(tree.operator.string).to eq("and")
            end

            it "should return a binary IRTree" do
              expect(tree.binary?).to be(true)
            end

            it "should have 'one' and 'two as children'" do
              children = tree.children
              expect(children[0].atom.string).to eq("one")
              expect(children[1 ].atom.string).to eq("two")
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
          let(:input) { "one and two and three"}
          include_examples "accept string"


          it "should contain additional child nodes" do
            expect(tree.children.empty?).to be(false)
          end
        end
      end

      context "n-ary sentence structure" do
        context "starting with a unary sentence" do
          let(:input) { "not one and two and three" }
          include_examples "accept string"
          include_examples "IRTree operator token", "and"
          it "should have a unary not sentence as the first child" do
            puts tree.inspect
            expect(tree.children.first.operator).to be_a(UnaryOperator)
          end
        end

        context "with simple non-nested atoms " do
          let(:input) { "one and two and three" }
          include_examples "accept string"
        end

        context "with simple non-nested atoms in parens" do
          let(:input) { "(one and two and three)" }
          include_examples "accept string"
        end

        context "with a series of unary operators" do
          let(:input) { "not one not two not three" }
          include_examples "reject string"
        end

        context "with an syntactically incorrect unary operator" do
          let(:input) { "one and two not three" }
          include_examples "reject string"
        end

        context "with three nested sentences " do
          context "with identical operators" do
            let(:input) { "(one) and (two) and (three)" }
            include_examples "accept string"
          end

          context "with differing operators" do
            let(:input) { "(one) and (two) or (three)" }
            include_examples "reject string"
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
