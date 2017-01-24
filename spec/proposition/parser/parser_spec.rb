require 'spec_helper'
module Proposition
  module Parser
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

      shared_examples_for "child atom order" do |atom_string_1, atom_string_2|
        it "should maintain the order of sub sentences" do
          expect(tree.children[0].atom.string).to eq(atom_string_1)
          expect(tree.children[1].atom.string).to eq(atom_string_2)
        end
      end

      describe "parse" do
        let(:parsed) { parser.parse }
        context "it should return a sentence data structure" do
          let(:input) { "raining and snowing;" }

          it "should return an array of propositional logic data structure" do
            expect(parsed).to be_a(Array)
            expect(parsed.count).to eq(1)
            expect(parsed.first).to be_a(::Proposition::Sentence)
          end

          context "without a terminal symbol" do
            let(:input) { "raining" }

            it "should reject the string" do
              expect { parser.parse } .to raise_error(Parser::ParseError)
            end
          end

          context "with a series of input sentences" do
            let(:input) { "raining; snowing; raining => snowing;" }

            it "should return three sentences" do
              expect(parsed.count).to eq(3)
            end
          end
        end
      end

      describe "parse_sentence" do
        context "with a single atom" do
          let(:input) { "raining;" }
          include_examples "IRTree type"

          it "should return shallow IR node" do
            tree = parser.parse_sentence
            expect(tree.leaf_node?).to be(true)
          end
        end

        context "with a unary sentence structure" do
          let(:input) { "not raining;" }
          include_examples "accept string"
          include_examples "IRTree type"
          include_examples "IRTree operator token", "not"

          context "with a tail" do
            let(:input) { "not raining or snowing;" }
            include_examples "accept string"
            include_examples "IRTree type"
            include_examples "IRTree operator token", "or"
          end

          context "within a n-ary sentence structure" do
            let(:input) { "snowing or not raining or misting;" }
            include_examples "accept string"
            include_examples "IRTree type"
            include_examples "IRTree operator token", "or"
          end

          context "with a nested string of unary operators" do
            let(:input) { "not not not raining;" }
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
              let(:input) { "snowing or not not raining or misting;" }
              include_examples "accept string"
              include_examples "IRTree type"
              include_examples "IRTree operator token", "or"
            end

            context "with an invalid sequence of unary operators" do
              let(:input) { "snowing or not raining not misting;" }
              include_examples "reject string"
            end
          end
        end

        context "binary sentence structure" do
          shared_examples_for "binary sentence" do |operator_string, child_1, child_2|
            include_examples "accept string"
            include_examples "IRTree type"

            context "tree structure" do
              include_examples "IRTree operator token", operator_string

              it "should return a binary IRTree" do
                expect(tree.binary?).to be(true)
              end

              include_examples "child atom order", child_1, child_2
            end
          end

          context "with parenthesis" do
            let(:input) { "(one and two);" }
            include_examples "accept string"
          end

          context "without parenthesis" do
            let(:input) { "one and two;" }
            include_examples "binary sentence", "and", "one", "two"
          end

          context "with a nested sentence" do
            let(:input) { "one and (two);" }
            include_examples "accept string"
          end

          context "with a two nested atoms in a binary sentence" do
            let(:input) { "(one) and (two);" }
            include_examples "accept string"
          end

          context "with an atom, followed by an optional tail" do
            let(:input) { "one and two and three;"}
            include_examples "accept string"


            it "should contain additional child nodes" do
              expect(tree.children.empty?).to be(false)
            end
          end

          context "with a binary operator" do
            context "implication" do
              let(:input) { "one => two" }
              include_examples "binary sentence", "=>", "one", "two"

              context "in parenthesis" do
                let(:input) { "(snowing and raining) => not sunny;"}

                include_examples "IRTree operator token", "=>"
              end
            end

            context "xor" do
              let(:input) { "one xor two" }
              include_examples "binary sentence", "xor", "one", "two"
            end

            context "biconditional" do
              let(:input) { "one <=> two" }
              include_examples "binary sentence", "<=>", "one", "two"
            end
          end
        end

        context "n-ary sentence structure" do
          context "starting with a unary sentence" do
            let(:input) { "not one and two and three;" }
            include_examples "accept string"
            include_examples "IRTree operator token", "and"
            it "should have a unary not sentence as the first child" do
              expect(tree.children.first.operator).to be_a(UnaryOperator)
            end
          end

          context "with simple non-nested atoms " do
            let(:input) { "one and two and three;" }
            include_examples "accept string"
          end

          context "with simple non-nested atoms in parens" do
            let(:input) { "(one and two and three);" }
            include_examples "accept string"
          end

          context "with a series of unary operators" do
            let(:input) { "not one not two not three;" }
            include_examples "reject string"
          end

          context "with an syntactically incorrect unary operator" do
            let(:input) { "one and two not three;" }
            include_examples "reject string"
          end

          context "with three nested sentences " do
            context "with identical operators" do
              let(:input) { "(one) and (two) and (three);" }
              include_examples "accept string"
            end

            context "with differing operators" do
              let(:input) { "(one) and (two) or (three);" }
              include_examples "reject string"
            end

            context "with nested n-ary sentences" do
              let(:input) { "((one and (two or four) and (three) and four) or (two) or three);" }
              include_examples "accept string"
            end
          end
        end
      end
    end
  end
end
