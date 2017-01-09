require 'spec_helper'
require_relative "token_fixtures"

module Proposition
  RSpec.shared_context "IRTree Fixtures" do
    include_context "token fixtures"
    let(:ir_tree_a) { IRTree.new(a_atom) }
    let(:ir_tree_b) { IRTree.new(b_atom) }
    let(:ir_tree_c) { IRTree.new(c_atom) }
    let(:ir_tree_d) { IRTree.new(d_atom) }

    let(:tail) { IRTree.new(nil, and_operator, [ir_tree_c, ir_tree_d]) }
    let(:ir_tree_a_or_b) { IRTree.new(nil, or_operator, [ir_tree_a, ir_tree_b]) }
    let(:ir_tree_a_and_b) { IRTree.new(nil, and_operator, [ir_tree_a, ir_tree_b]) }
  end
end
