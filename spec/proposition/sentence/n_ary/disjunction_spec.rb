require 'spec_helper'
require_relative '../../sentence_fixtures'

module Proposition
  RSpec.describe Disjunction do
    describe "operator" do
      it "should return OR" do
        expect(Disjunction.new([]).operator).to eq("OR")
      end
    end
  end
end
