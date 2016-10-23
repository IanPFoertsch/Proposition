require 'spec_helper'

module Proposition
  RSpec.describe Lexer do


    describe "next_token" do
      let(:lexer) { Lexer.new(input) }



      context "identifiers" do
        let(:input) { "raining"}
        it "should consume a string of characters as an identifier" do
          expect(lexer.next_token.string).to eq(input)
        end

        context "return type" do
          it "should return a token" do
            expect(lexer.next_token).to be_a(Atom)
          end
        end

        context "seperated by spaces" do
          let(:input) { "raining and cloudy" }

          it "should return a series of identifiers" do
            expect(lexer.next_token.string).to eq("raining")
            expect(lexer.next_token.string).to eq("and")
            expect(lexer.next_token.string).to eq("cloudy")
          end
        end

        context "with underscores" do
          let(:input) { "i_am_an_identifier" }

          it "should treat underscores as characters" do
            expect(lexer.next_token.string).to eq(input)
          end


        end

        context "with underscores and digits" do
          let(:input) { "identifier_1 identifier_2" }
          it "should recognize identifiers with underscores and digits" do
            expect(lexer.next_token.string).to eq("identifier_1")
            expect(lexer.next_token.string).to eq("identifier_2")
          end
        end
      end

      context "operators" do
        let(:operators) { ["and", "or", "xor", "=>", "<=>"] }
        it "should recognize the following as operators" do
          operators.each do |operator|
            lexer = Lexer.new(operator)
            expect(lexer.next_token).to be_a(Operator)
          end
        end
      end

      context "parenthesis" do
        let(:input) { "()" }

        it "should recognize parenthesis" do
          expect(lexer.next_token).to be_a(Parenthesis)
          expect(lexer.next_token).to be_a(Parenthesis)
        end
      end
    end
  end
end
