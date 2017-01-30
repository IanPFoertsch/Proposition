require 'spec_helper'
require_relative 'ir_tree_fixtures'

module Proposition
  module Parser
    RSpec.describe IRTree do
      include_context "IRTree Fixtures"

      describe "push" do
        context "with a leaf node" do
          context "and another leaf node" do
            it "should raise an error" do
              expect { ir_tree_a.append(ir_tree_b) }.to raise_error(ArgumentError)
            end
          end

          context "and a binary tree" do
            let(:merged) { ir_tree_a.append(tail) }

            it "should merge the two trees" do
              expect { ir_tree_a.append(tail) }.not_to raise_error
            end

            it "should include the operator" do
              expect(merged.operator).to eq(tail.operator)
            end

            it "should preserve the order of the componenets" do
              children = merged.children
              expect(children.length).to eq(3)
              expect(children[0].atom).to eq(ir_tree_a.atom)
              expect(children[1].atom).to eq(ir_tree_c.atom)
            end
          end
        end
      end

      describe "left_append" do
        context "with a leaf node" do
          it "should raise an Error" do
            expect{ ir_tree_a.left_append(tail) }.to raise_error(ArgumentError)
          end
        end

        context "with a non-leaf node operand" do
          let(:four) { IRTree.new(Atom.new("four")) }
          let(:operand) { IRTree.new(nil, Operator.new("not"), four) }
          let(:appended) { tail.left_append(operand) }

          it "should return an IRTree" do
            expect(appended).to be_a(IRTree)
          end

          it "should contain the original operand as a child in the leftmost positions" do
            negated = appended.children[0]
            expect(negated.operator.string).to eq("not")
            expect(negated.children.first.atom.string).to eq(four.atom.string)
          end

          it "should contain the subject's children in the rightmost positions" do
            expect(appended.children[1].atom).to eq(ir_tree_c.atom)
            expect(appended.children[2].atom).to eq(ir_tree_d.atom)
          end
        end
      end
    end
  end
end
