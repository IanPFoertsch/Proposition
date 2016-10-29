 require 'spec_helper'
module Proposition
  RSpec.describe Parser do
    let(:parser) { Parser.new(input) }

    context "with a string of atoms" do
      let(:input) { "one two three" }
      it "should accept a string of atoms" do
        expect { parser.parse } .not_to raise_error
      end
    end

    context "binary sentence structure" do
      context "with parenthesis" do
        let(:input) { "(one and two)" }
        it "accept a valid sentence" do
          expect { parser.parse }.not_to raise_error
        end
      end

      context "without parenthesis" do
        let(:input) { "one and two" }
        it "accept a valid sentence" do
          expect { parser.parse }.not_to raise_error
        end
      end
    end
  end
end
