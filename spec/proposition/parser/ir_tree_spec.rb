require 'spec_helper'

module Proposition
  RSpec.describe IRTree do
    describe "left_concatenate" do
      #Need to support the idea of "pushing" a tree into another tree, from the
      #left
      let(:tree) { IRTree.new(Atom.new("one")) }
      let(:two) { IRTree.new(Atom.new("two")) }
      let(:tail) { IRTree.new(nil, Operator.new("and"), two, three )}
      let(:three) { IRTree.new(Atom.new("three")) }

      it "should concatenate from the left" do
        merged = tail.left_concatenate(tree)
        expect(merged.left).to eq(tree)
        expect(merged.right).to eq(two)
        expect(merged.others).to eq([three])
      end
    end
  end
end
