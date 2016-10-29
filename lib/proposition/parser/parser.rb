module Proposition
  class Parser
    def initialize(input)
      @input = input
    end

    def lexer
      @lexer ||= Lexer.new(@input)
    end

    def parse
      while lexer.look_ahead(0)
        parse_sentence
      end
    end

    def parse_sentence
      next_token = lexer.look_ahead(0)

      case next_token
      when Atom
        parse_atomic_or_binary_sentence
      when Parenthesis
        parse_within_parenthesis(:parse_atomic_or_binary_sentence)
      end
    end

    def parse_atomic_or_binary_sentence
      current = lexer.look_ahead(0)
      next_token = lexer.look_ahead(1)
      if current.is_a?(Atom) && next_token.is_a?(Operator)
        parse_binary_sentence
      else
        parse_atomic_sentence
      end
    end

    def parse_atomic_sentence
      atom = lexer.get_next_token
      unless atom.is_a?(Atom)
        raise "ParseError: Expecting an operator"
      end
    end

    def parse_binary_sentence
      parse_atomic_sentence
      parse_operator
      parse_atomic_sentence
    end

    def parse_operator
      operator = lexer.get_next_token
      unless operator.is_a?(Operator)
        raise "ParseError: Expecting an operator"
      end
    end

    def parse_within_parenthesis(method)
      #our current token will be a parenthesis,
      #so we need to consume the parenthesis
      open_parenthesis = lexer.get_next_token
      unless open_parenthesis.is_a?(Parenthesis) &&
        open_parenthesis.string == "("
        raise "ParseError: Expecting token '('"
      end
      self.send(method)
      close_parenthesis = lexer.get_next_token
      unless close_parenthesis.is_a?(Parenthesis) &&
        close_parenthesis.string == ")"
        raise "ParseError: Expecting token ')'"
      end
    end
  end
end
