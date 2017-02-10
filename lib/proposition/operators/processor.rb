require 'set'
module Proposition
  #TODO: Rename me something less lame than "processor"
  class Processor
    def entails?(kb_string, query_string)
      knowledge_base = Parser::Parser.new(kb_string).parse
      query = Parser::Parser.new(query_string).parse

      pl_resolution(knowledge_base, query)
    end

    def self.pl_resolution(knowledge_base, query)
      not_query = Not.new(query)
      kb_and_not_query = And.new(knowledge_base, not_query)

      cnf = kb_and_not_query.to_conjunctive_normal_form
      puts cnf.inspect
    end
  end
end
