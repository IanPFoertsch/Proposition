
module Proposition
  class Processor
    def self.pl_resolution(knowledge_base, query)
      #generate a new sentence from KB AND (NOT (Query))
      not_query = CompoundSentence.new(query, Logic::NOT)
      combined = CompoundSentence.new(knowledge_base, Logic::AND, not_query)

      cnf = build_cnf_sentence(combined)

    end
  end
end
