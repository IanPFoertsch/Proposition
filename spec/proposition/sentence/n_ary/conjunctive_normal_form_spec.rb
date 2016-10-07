require 'spec_helper'
require_relative '../../sentence_fixtures'

module Proposition
  RSpec.describe ConjunctiveNormalForm do
    describe "initialize" do
      let(:clause) { Clause.new([]) }

      context "with a non-clause arguement sentence" do

        let(:not_clause) { AtomicSentence.new("a")}

        it "should throw an exception" do
          expect { ConjunctiveNormalForm.new([clause, not_clause]) }
            .to raise_error("ConjunctiveNormalForm initialized with a non-clause component sentence")
        end
      end

      context "with only clause arguements" do
        it "should not throw an exception" do
          expect { ConjunctiveNormalForm.new([clause]) } .not_to raise_error
        end
      end
    end
  end
end
