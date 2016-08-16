module Proposition
  class NArySentence < Sentence
    attr_reader :operator, :sentences

    def initialize(operator, sentences, *other_sentences)
      @operator = operator

      if sentences.is_a?(Array)
        @sentences = sentences
      else
        @sentences = [sentences] + other_sentences
      end
    end

    def in_text
      "(#{@sentences.map { |s| s.in_text }.join(' ' + @operator + ' ')})"
    end

    #a clause in propositional logic is an n-ary sentence with an OR operator
    #and only atomic components
    def is_clause?

      return false if @operator != Logic::OR

      @sentences.each do |sentence|
        return false if !sentence.is_atomic?
      end

      true
    end

    def retrieve_atomic_components
      @sentences.each do |sentence|
        unless sentence.is_a?(AtomicSentence)
          raise "Retreiving Atomic Components on an N Ary Sentence containing "\
            "non-atomic components"
        end
      end
      @sentences.clone
    end

    def resolve(add_me)
      if @sentences.include?(add_me.negate)
        return NArySentence.new(@operator, @sentences.clone.reject { |s| s == add_me.negate })
      elsif @sentences.include?(add_me)
        self
      else
        NArySentence.new(@operator, @sentences.clone + [add_me])
      end
    end

    def empty?
      return @sentences.empty?
    end
  end
end
