require 'spec_helper'

module Proposition
  RSpec.describe Lexer do


    context "next_token" do
      let(:lexer) { Lexer.new(input) }

      context "identifiers" do
        let(:input) { "raining"}
        it "should consume a string of characters as an identifier" do
          expect(lexer.next_token).to eq(input)
        end

        context "seperated by spaces" do
          let(:input) { "raining and cloudy" }

          it "should return a series of identifiers" do
            expect(lexer.next_token).to eq("raining")
            expect(lexer.next_token).to eq("and")
            expect(lexer.next_token).to eq("cloudy")
          end
        end

        context "with underscores" do
          let(:input) { "i_am_an_identifier" }

          it "should treat underscores as characters" do
            expect(lexer.next_token).to eq(input)
          end


        end

        context "with underscores and digits" do
          let(:input) { "identifier_1 identifier_2" }
          it "should recognize identifiers with underscores and digits" do
            expect(lexer.next_token).to eq("identifier_1")
            expect(lexer.next_token).to eq("identifier_2")
          end
        end
      end
    end
  end
end
