require 'spec_helper'

module Proposition
  RSpec.describe IRTree do


    describe "push" do

      context "with a leaf node" do
        let(:leaf) { IRTree.new(Atom.new("one")) }

        context "and another leaf node" do
          let(:other_leaf) { IRTree.new(Atom.new("other")) }
          it "should raise an error" do
            expect { leaf.append(other_leaf) }.to raise_error(ArgumentError)
          end
        end

        context "and a binary tree" do
          let(:two) { IRTree.new(Atom.new("two")) }
          let(:three) { IRTree.new(Atom.new("three")) }
          let(:tail) { IRTree.new(nil, Operator.new("and"), [two, three] )}
          let(:merged) { leaf.append(tail) }

          it "should merge the two trees" do
            expect { leaf.append(tail) }.not_to raise_error
          end

          it "should include the operator" do
            expect(merged.operator).to eq(tail.operator)
          end

          it "should preserve the order of the componenets" do
            children = merged.children
            expect(children.length).to eq(3)
            expect(children[0].atom).to eq(leaf.atom)
            expect(children[1].atom).to eq(two.atom)
          end

          it "should replicate the existing children" do
            
          end
        end
      end
    end
  end
end
