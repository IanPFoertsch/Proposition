require 'spec_helper'
require_relative '../../sentence_fixtures'

module Proposition
  RSpec.describe BinarySentence do
    let(:a) { AtomicSentence.new("a") }
    let(:b) { AtomicSentence.new("b") }
    let(:c) { AtomicSentence.new("c") }
    let(:d) { AtomicSentence.new("d") }
    let(:binary_sentence) { BinarySentence.new(a, b) }
    let(:a_and_b) { And.new(a, b)}
    let(:c_or_d) { And.new(c, d)}

    describe "distribute_or" do
      let(:c) { AtomicSentence.new("c") }
      let(:distributed) { binary_sentence.distribute_or(c) }
      it "should create new Or sentences as the new left and right subsentences" do
        expect(distributed.instance_variable_get(:@left).is_a?(Or)).to be(true)
        expect(distributed.instance_variable_get(:@right).is_a?(Or)).to be(true)
      end

      it "should instantiate a new instance of the same class" do
        expect(distributed.is_a?(BinarySentence)).to be(true)
      end

      it "should distribute the subject into the new sentence" do
        expect(distributed.instance_variable_get(:@left).instance_variable_get(:@left)).to eq(c)
        expect(distributed.instance_variable_get(:@right).instance_variable_get(:@left)).to eq(c)
      end
    end

    describe "distribute_or" do
      let(:distributed) { binary_sentence.distribute_and(c) }
      it "should create new Or sentences as the new left and right subsentences" do
        expect(distributed.instance_variable_get(:@left).is_a?(And)).to be(true)
        expect(distributed.instance_variable_get(:@right).is_a?(And)).to be(true)
      end

      it "should instantiate a new instance of the same class" do
        expect(distributed.is_a?(BinarySentence)).to be(true)
      end

      it "should distribute the subject into the new sentence" do
        expect(distributed.instance_variable_get(:@left).instance_variable_get(:@left)).to eq(c)
        expect(distributed.instance_variable_get(:@right).instance_variable_get(:@left)).to eq(c)
      end
    end

    describe "push_operation_down" do
      shared_examples "test operation" do
        it "should respond to the method" do
          expect(binary_sentence.respond_to?(method_symbol)).to be(true)
        end

        it "should pass the operation into the left and right subsentences" do
          expect(binary_sentence.instance_variable_get(:@left)).to receive(method_symbol)
          expect(binary_sentence.instance_variable_get(:@right)).to receive(method_symbol)
          binary_sentence.send(method_symbol)
        end

        it "should create and return a new sentence" do
          pushed = binary_sentence.send(method_symbol)
          expect(pushed).not_to be(binary_sentence)
        end
      end

      context "push_not_down" do
        let(:method_symbol) { :push_not_down}
        include_examples "test operation"
      end

      context "push_or_down" do
        let(:method_symbol) { :push_or_down}
        include_examples "test operation"
      end

      context "push_and_down" do
        let(:method_symbol) { :push_and_down}
        include_examples "test operation"
      end
    end

    describe "==" do
      it "should be false if the other sentence is not an instance of the same class" do
        expect(binary_sentence == c).to be(false)
      end
      context "when being compared to an instance of the same class" do
        context "with a different left subsentence" do
          let(:other) { BinarySentence.new(c, b)}
          it "should be false" do
            expect(binary_sentence).not_to eq(other)
          end
        end

        context "with a different right subsentence" do
          let(:other) { BinarySentence.new(a, c)}
          it "should be false" do
            expect(binary_sentence).not_to eq(other)
          end
        end

        context "with an identical sentence" do
          let(:other) { BinarySentence.new(a, b)}
          it "should be true" do
            expect(binary_sentence).to eq(other)
          end
        end
      end
    end

    describe "rotate" do
      it "should return a new sentence with reversed left and right subsentences" do
        expect(binary_sentence.rotate).to eq(BinarySentence.new(b, a))
      end
    end
  end
end
