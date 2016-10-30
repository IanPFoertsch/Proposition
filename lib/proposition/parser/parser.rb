module Proposition
  class Parser
    class ParseError < StandardError
      def initialize(message)
        super("ParseError: #{message}")
      end
    end

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
      current = lexer.look_ahead(0)
      next_token = lexer.look_ahead(1)
      if current.is_a?(Parenthesis)
        parse_sentence_in_parenthesis
      elsif current.is_a?(Atom) && next_token.is_a?(Operator)
        parse_compound_sentence
      else
        parse_atomic_sentence
      end
    end

    def parse_atomic_sentence
      atom = lexer.get_next_token
      unless atom.is_a?(Atom)
        raise ParseError.new("Expecting an operator")
      end
    end

    def parse_compound_sentence
      parse_sentence
      operator = parse_operator
      parse_sentence
      while lexer.look_ahead(0).is_a?(Operator)
        unless operator.string == lexer.get_next_token.string
          raise ParseError.new("operator types in n-ary sentences must be identical")
        end
        parse_sentence
      end
      #if the next token is nil or a closing parens, end here
      #otherwise, expect another operator, and another atom.
      #asset that the other operator is identical to the first,
    end

    def parse_operator
      operator = lexer.get_next_token
      unless operator.is_a?(Operator)
        raise ParseError.new("Expecting an operator")
      end
      operator
    end

    def parse_sentence_in_parenthesis
      #our current token will be a parenthesis,
      #so we need to consume the parenthesis
      open_parenthesis = lexer.get_next_token
      unless open_parenthesis.is_a?(Parenthesis) &&
        open_parenthesis.string == "("
        raise ParseError.new("Expecting token '('")
      end
      parse_sentence
      close_parenthesis = lexer.get_next_token
      unless close_parenthesis.is_a?(Parenthesis) &&
        close_parenthesis.string == ")"
        raise ParseError.new("Expecting token ')'")
      end
    end
  end
end
