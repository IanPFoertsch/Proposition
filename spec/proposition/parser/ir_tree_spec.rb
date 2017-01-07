require 'spec_helper'

module Proposition
  RSpec.describe IRTree do
    let(:leaf) { IRTree.new(Atom.new("one")) }
    let(:other_leaf) { IRTree.new(Atom.new("other")) }
    let(:two) { IRTree.new(Atom.new("two")) }
    let(:three) { IRTree.new(Atom.new("three")) }
    let(:tail) { IRTree.new(nil, Operator.new("and"), [two, three] )}

    describe "push" do
      context "with a leaf node" do
        context "and another leaf node" do
          it "should raise an error" do
            expect { leaf.append(other_leaf) }.to raise_error(ArgumentError)
          end
        end

        context "and a binary tree" do
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
        end
      end
    end

    describe "left_append" do
      context "with a leaf node operand" do
        it "should raise an Error" do
          expect{ tail.left_append(leaf) }.to raise_error(ArgumentError)
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
          expect(appended.children[1].atom).to eq(two.atom)
          expect(appended.children[2].atom).to eq(three.atom)
        end
      end
    end
  end
end
