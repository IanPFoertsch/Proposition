module Proposition
  class KnowledgeBase
    def initialize
      @sentences = []
    end

    def push(sentence)
      @sentences.push(sentence)
    end

    def in_text
      string = ""
      @sentences.each do |sentence|
        string.concat("#{sentence.in_text}\n")
      end
      string
    end

    def count
      @sentences.count
    end
  end
end
