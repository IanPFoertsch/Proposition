require_relative "../sentence"
module Proposition
  class NArySentence < Sentence
    attr_reader :sentences

    def initialize(sentences)
      @sentences = sentences
    end

    def conjoin(other)
      raise "other sentence is not an NArySentence" unless other.is_a?(NArySentence)

      NArySentence.new(@sentences + other.sentences)
    end
  end
end
