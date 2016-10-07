require_relative "n_ary_sentence"
require_relative "conjunction"
module Proposition
  class ConjunctiveNormalForm < Conjunction
    def initialize(sentences)
      sentences.each do |sentence|
        unless sentence.is_a?(Clause)
          raise "ConjunctiveNormalForm initialized with a non-clause component sentence"
        end
      end
      super(sentences)
    end
  end
end
