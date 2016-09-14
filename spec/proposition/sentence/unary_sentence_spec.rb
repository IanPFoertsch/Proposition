require 'spec_helper'
require_relative '../sentence_fixtures'

module Proposition
  RSpec.describe UnarySentence do
    include_context "sentence fixtures"

    context "in_text" do
      let(:unary_sentence) { UnarySentence.new(a_or_b) }

      it "should return the sentence's text value wrapped in 'NOT ...'" do
        expect(unary_sentence.in_text).to eq("NOT #{a_or_b.in_text}")
        puts unary_sentence.in_text
      end

    end
  end
end
