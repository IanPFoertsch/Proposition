
module Proposition
  class Processor
    def self.pl_resolution(knowledge_base, query)
      not_query = NegatedSentence.new(query)
      combined = And.new(knowledge_base, not_query)

      cnf = combined.to_conjunctive_normal_form
      puts cnf.inspect
    end
  end
end
