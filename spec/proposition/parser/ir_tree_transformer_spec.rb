require 'spec_helper'
require_relative 'ir_tree_fixtures'
require_relative "../sentence_fixtures"
module Proposition
  module Parser
    RSpec.describe IRTreeTransformer do
      include_context "IRTree Fixtures"
      include_context "sentence fixtures"

      shared_examples_for "transforms to logical data structure" do
        it "should transform to an #{And} sentence" do
          expect(transformed).to be_a(expected_class)
        end

        it "should contain the subsentences as left and right sub-sentences" do
          expect(transformed.left).to eq(left)
          expect(transformed.right).to eq(right)
        end
      end

      describe "transform" do
        context "IRTree leaf nodes"

        it "should transform leaf nodes to atomic sentences" do
          expect(IRTreeTransformer.transform(ir_tree_a)).to eq(a)
        end

        context "with a unary not operator" do
          let(:transformed) { IRTreeTransformer.transform(ir_tree_not_a) }
          it "should transform to a Not sentence" do
            expect(transformed).to be_a(NegatedSentence)
          end

          it "should contain the IRTree's child as a sub-sentence" do
            expect(transformed.sentence).to eq(a)
          end
        end

        context "binary ir_trees operators" do
          context "with an with an #{Lexer::AND} operator" do
            let(:transformed) { IRTreeTransformer.transform(ir_tree_a_and_b) }
            let(:expected_class) { And }
            let(:left) { a }
            let(:right) { b }

            include_examples "transforms to logical data structure"
          end

          context "with an with an #{Lexer::OR} operator" do
            let(:transformed) { IRTreeTransformer.transform(ir_tree_a_or_b) }
            let(:expected_class) { Or }
            let(:left) { a }
            let(:right) { b }

            include_examples "transforms to logical data structure"
          end
        end

        context "n-ary and ir_trees" do
          context "with a symmetrical, balanced tree" do
            let(:transformed) { IRTreeTransformer.transform(ir_tree_4_ary_and) }
            let(:expected_class) { And }
            let(:left) { a_and_b }
            let(:right) { c_and_d }
            include_examples "transforms to logical data structure"
          end

          context "with a assymetrical tree" do
            let(:transformed) { IRTreeTransformer.transform(ir_tree_3_ary_and) }
            let(:expected_class) { And }
            let(:left) { a_and_b }
            let(:right) { c }
            include_examples "transforms to logical data structure"
          end

          context "with a deeply nested 8 member tree" do
            let(:transformed) { IRTreeTransformer.transform(ir_tree_8_ary_and) }
            let(:expected_class) { And }
            let(:left) { a_and_b_and_c_and_d }
            let(:right) { a_and_b_and_c_and_d }

            include_examples "transforms to logical data structure"
          end

          context "with mixed operators" do
            let(:transformed) { IRTreeTransformer.transform(ir_tree_8_mixed_operator) }
            let(:expected_class) { Or }
            let(:left) { a_and_b_or_c_and_d_or_d }
            let(:right) { e_or_f }

            include_examples "transforms to logical data structure"
          end
        end
      end
    end
  end
end
