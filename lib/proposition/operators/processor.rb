
module Proposition
  class Processor
    def self.build_cnf_sentence(sentence)
      #TODO: Move this into the sentence classes
      #given a sentence, execute the following:
      # 1.) eliminate XOR, IMPLICATION, BICONDITIONAL
      eliminated = sentence
        .eliminate_operator(Logic::BICONDITIONAL)
        .eliminate_operator(Logic::IMPLICATION)
        .eliminate_operator(Logic::XOR)
        .push_not_down
        .push_or_down

      recurse_to_or(eliminated).first
    end

    def self.recurse_to_or(sentence)
      #TODO Push this asking, not telling block into the sentence classes
      if sentence.is_atomic?
        return [sentence]
      elsif sentence.is_compound?
        if sentence.operator == Logic::OR
          left_components = retrieve_atomic_components(sentence.left)
          right_components = retrieve_atomic_components(sentence.right)

          [ NArySentence.new(Logic::OR, left_components + right_components) ]

        elsif sentence.is_unary?
          return recurse_to_or(sentence.push_not_down)
        else
          left = recurse_to_or(sentence.left)
          right = recurse_to_or(sentence.right)

          [ NArySentence.new(Logic::AND, left + right) ]
        end
      end
    end


    def self.retrieve_atomic_components(sentence)
      if sentence.is_atomic?
        [sentence]
      elsif sentence.is_compound?
        if sentence.is_unary?
          return retrieve_atomic_components(sentence.push_not_down)
        else
          left_components = retrieve_atomic_components(sentence.left)
          right_components = retrieve_atomic_components(sentence.right)

          return left_components + right_components
        end
      end
    end

    #given 2 sentences, a knowledge_base, and a query,
    #test if the KB entails the query
    def self.pl_resolution(knowledge_base, query)
      #generate a new sentence from KB AND (NOT (Query))
      not_query = CompoundSentence.new(query, Logic::NOT)
      combined = CompoundSentence.new(knowledge_base, Logic::AND, not_query)

      cnf = build_cnf_sentence(combined)

      #retreive the sentences from the cnf and operate on that

    end
  end
end
