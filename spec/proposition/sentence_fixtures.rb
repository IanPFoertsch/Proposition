require 'spec_helper'

module Proposition
  RSpec.shared_context "sentence fixtures" do
    let(:a) { AtomicSentence.new("A") }
    let(:b) { AtomicSentence.new("B") }
    let(:c) { AtomicSentence.new("C") }
    let(:d) { AtomicSentence.new("D") }
    let(:e) { AtomicSentence.new("E") }
    let(:f) { AtomicSentence.new("F") }
    let(:g) { AtomicSentence.new("G") }

    let(:a_or_b) { Or.new(a, b) }
    let(:c_or_d) { Or.new(c, d) }
    let(:a_and_b) { And.new(a, b) }
    let(:c_and_d) { And.new(c, d) }

    let(:a_and_b_and_c_and_d) { And.new(a_and_b, c_and_d) }
    let(:a_and_b_or_c_and_d) { Or.new(a_and_b, c_and_d) }
    let(:a_and_b_or_c_and_d_or_d) { Or.new(a_and_b_or_c_and_d, d) }
    let(:e_or_f) { Or.new(e, f) }

    let(:not_a) { Not.new(a) }
    let(:not_b) { Not.new(b) }

    let(:a_and_not_b) { And.new(a, not_b) }
    let(:not_a_and_b) { And.new(not_a, b) }

    let(:a_or_not_b) { Or.new(a, not_b) }
    let(:not_a_or_b) { Or.new(not_a, b) }

    let(:clause_a_b_c) { Clause.new([a, b, c]) }
    let(:clause_not_a_not_b) { Clause.new([not_a, not_b]) }
    let(:clause_c) { Clause.new([c]) }

    let(:n_ary_a_b_c) { NArySentence.new([a, b, c]) }
  end
end
