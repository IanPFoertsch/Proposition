 require 'spec_helper'
module Proposition
  RSpec.describe Parser do
    let(:parser) { Parser.new(input) }

    shared_examples_for "accept string" do
      it "should accept the input string" do
        expect { parser.parse } .not_to raise_error
      end
    end

    context "with a string of atoms" do
      let(:input) { "one two three" }
      include_examples "accept string"
    end

    context "binary sentence structure" do
      context "with parenthesis" do
        let(:input) { "(one and two)" }
        include_examples "accept string"
      end

      context "without parenthesis" do
        let(:input) { "one and two" }
        include_examples "accept string"
      end

      context "with a nested sentence" do
        let(:input) { "one and (two)" }
        include_examples "accept string"
      end
    end

    context "with n-ary sentence structure" do
      let(:input) { "(one and two and three)" }
      include_examples "accept string"
    end
  end
end
