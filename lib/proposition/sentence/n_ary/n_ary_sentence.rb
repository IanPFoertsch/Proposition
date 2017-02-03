require_relative "../sentence"
require_relative "../logic"
module Proposition
  class NArySentence < Sentence

    def initialize(sentences)
      sorted = sentences.sort_by { |s| s.in_text }
      @sentences = sorted
    end

    def conjoin(other)
      raise "other sentence is not an NArySentence" unless other.is_a?(NArySentence)

      self.class.new(@sentences + other.sentences)
    end

    def sentences
      Marshal.load(Marshal.dump(@sentences))
    end

    def operator
      raise NotImplementedError
    end

    def in_text
      "(#{sentences.map {|s| s.in_text}.join(' ' + operator + ' ')})"
    end

    def ==(other)
      return false unless other.is_a?(self.class)
      return false unless other.sentences.size == @sentences.size
      @sentences.all? { |sentence| other.sentences.include?(sentence) }
    end
  end
end
