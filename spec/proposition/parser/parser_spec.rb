 require 'spec_helper'
module Proposition
  RSpec.describe Parser do
    let(:lexer) { Lexer.new("Dummy") }
    let(:parser) { Parser.new("Dummy") }

    context "with a string of atoms" do
      let(:atom_1) { Atom.new("1") }
      let(:atom_2) { Atom.new("2") }
      let(:atom_3) { Atom.new("3") }

      before do
        allow(Lexer).to receive(:new).and_return(lexer)
        allow(lexer).to receive(:has_more_tokens).and_return(true, true, false)
        allow(lexer).to receive(:next_token).and_return(
          atom_1,
          atom_2,
          atom_3
        )
      end
      it "should accept a string of atoms" do
        expect { parser.parse } .not_to raise_error
      end
    end

    context "with a sentence structure of atom operator atom" do
      let(:atom_1) { Atom.new("1") }
      let(:operator) { Operator.new("and") }
      let(:atom_3) { Atom.new("3") }

      before do
        allow(Lexer).to receive(:new).and_return(lexer)
        allow(lexer).to receive(:has_more_tokens).and_return(true, true, false)
        allow(lexer).to receive(:next_token).and_return(
          atom_1,
          operator,
          atom_3
        )
      end

      it "should accept a string of atoms" do
        expect { parser.parse }.not_to raise_error
      end

    end
  end
end
