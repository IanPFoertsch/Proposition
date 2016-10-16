
module Proposition
  class Parser
    STATEMENT_DELIMITERS = ["\n", ";"]

    def self.build_model(input_string)
      model = {}
      tokens = Lexer.tokenize(input_string, STATEMENT_DELIMITERS)

      tokens.each do |token|
        model[token] = true
      end
      model
    end

    
  end
end
