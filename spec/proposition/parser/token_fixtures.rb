require 'spec_helper'

module Proposition
  module Parser
    RSpec.shared_context "token fixtures" do
      let(:a_atom) { Atom.new("A") }
      let(:b_atom) { Atom.new("B") }
      let(:c_atom) { Atom.new("C") }
      let(:d_atom) { Atom.new("D") }
      let(:e_atom) { Atom.new("E") }
      let(:f_atom) { Atom.new("F") }

      let(:or_operator) { NAryOperator.new("or") }
      let(:and_operator) { NAryOperator.new("and") }
      let(:not_operator) { UnaryOperator.new("not") }
    end
  end
end
