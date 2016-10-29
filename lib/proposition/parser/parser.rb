module Proposition
  class Parser
    def initialize(input)
      @input = input
    end

    def parse
      consume()
      while look_ahead
        #match the tokens:

        unless match_atom(look_ahead)
          raise "Parse Error"
        end
      end
    end

    def parse_sentence
      #either match an atom, or a binary sentence
      match_atom(token)
      match_operator(token)
      match_atom(token)
    end

    def match_atom(token)
      if token.is_a?(Atom)
        consume()
        return true
      else
        false
      end
    end



    def look_ahead
      #build a queue of lookahead tokens
      @look_ahead
    end

    def consume
      if lexer.has_more_tokens
        @look_ahead = lexer.next_token
      else
        @look_ahead = nil
      end
    end

    def lexer
      @lexer ||= Lexer.new(@input)
    end
  end
end
