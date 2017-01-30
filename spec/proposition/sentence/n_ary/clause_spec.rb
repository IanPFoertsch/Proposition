require 'spec_helper'
require_relative '../../sentence_fixtures'

module Proposition
  RSpec.describe Clause do

    describe "initialization" do
      it "should raise an error when give a non-atomic sentence" do

      end

    end

    describe "resolve" do
      include_context "sentence fixtures"
      let(:resolved) { resolver.resolve(resolvent) }

      shared_examples_for "should contain the expected atoms" do
        it "should contain the atom" do

          should_contain.each do |atom|
            expect(resolved.contains?(atom)).to be(true)
          end

          should_not_contain.each do |atom|
            expect(resolved.contains?(atom)).to be(false)
          end

        end
      end

      context "with complimentary sentences" do
        let(:resolver) { clause_a_b_c }
        let(:resolvent) { clause_not_a_not_b}
        let(:should_contain) { [c] }
        let(:should_not_contain) { [a, b] }
        include_examples "should contain the expected atoms"
      end
    end
  end
end
