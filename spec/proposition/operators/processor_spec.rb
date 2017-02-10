require 'spec_helper'
require_relative "../sentence_fixtures"
module Proposition
  RSpec.describe Processor do
    include_context "sentence fixtures"

    describe "sets of clauses" do
      let(:kb) { Conjunction.new([clause_a_b_c, clause_c]) }
      let(:set) { Set.new(kb.sentences) }
      let(:set_clause_c) { [clause_c].to_set }
      it "should identify subsets" do
        expect(set.subset?(set_clause_c)).to be(false)
        expect(set_clause_c.subset?(set)).to be(true)
      end
    end

    describe "pl_resolution" do
      

    end
  end
end
