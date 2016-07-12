module Proposition
  RSpec.describe Processor do
    let(:a) { AtomicSentence.new("A") }
    let(:b) { AtomicSentence.new("B") }
    let(:c) { AtomicSentence.new("C") }
    let(:d) { AtomicSentence.new("D") }
    let(:e) { AtomicSentence.new("E") }
    let(:f) { AtomicSentence.new("F") }
    let(:g) { AtomicSentence.new("G") }

    let(:a_or_b) { CompoundSentence.new(a, Logic::OR, b) }
    let(:c_or_d) { CompoundSentence.new(c, Logic::OR, d) }
    let(:e_or_f) { CompoundSentence.new(e, Logic::OR, f) }
    let(:left_or) { CompoundSentence.new(a_or_b, Logic::OR, c_or_d) }
    let(:right_or) { CompoundSentence.new(left_or, Logic::OR, e_or_f) }

    let(:g_and_others) { CompoundSentence.new(g, Logic::AND, right_or) }

    let(:not_sentence) { CompoundSentence.new(a, Logic::NOT) }
    let (:compound_sentence) {CompoundSentence.new(a, Logic::AND, b)}
    let(:a_and_b) { CompoundSentence.new(a, Logic::AND, b) }
    let(:c_implication_d) { CompoundSentence.new(c, Logic::IMPLICATION, d) }

    let(:complex_compound) { CompoundSentence.new(a_and_b, Logic::XOR, c_implication_d) }

    let(:c_and_d) { CompoundSentence.new(c, Logic::AND, d) }
    let(:complex) { CompoundSentence.new(a_and_b, Logic::AND, c_and_d) }
    let(:f_or_complex) { CompoundSentence.new(f, Logic::OR, complex) }

    describe "retrieve_atomic_components" do
      it "should extract the atomic components" do
        Processor.retrieve_atomic_components(f_or_complex)
      end
    end

    describe "build_cnf_sentence" do
      let(:expected) { "(G AND (A OR B OR C OR D OR E OR F))" }
      it "should extract the atomic components to an array of arrays" do
        expect(Processor.build_cnf_sentence(g_and_others).in_text).to eq(expected)
      end
    end
  end
end
