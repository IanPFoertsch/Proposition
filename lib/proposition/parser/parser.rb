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
      while look_ahead
        return parse_sentence
      end
    end

    ##TODO: Add support for NOT Keyword
    def parse_sentence
      current = look_ahead
      if current.is_a?(Parenthesis)
        parse_sentence_in_parenthesis
        parse_optional_sentence_tail
      else
        tree = parse_atomic_sentence
        tail = parse_optional_sentence_tail
        if tail
          return tree.append(tail)
        else
          return tree
        end
      end
    end

    def parse_atomic_sentence
      atom = lexer.get_next_token
      unless atom.is_a?(Atom)
        raise ParseError.new("Expecting an atom")
      end
      IRTree.new(atom)
    end

    def parse_optional_sentence_tail
      if look_ahead.is_a?(Operator)
        operator = parse_operator
        tail = parse_sentence_without_optional_tail

        if look_ahead.is_a?(Operator)
          components = parse_n_ary_components(operator)
        end
        return IRTree.new(nil, operator, [tail])
      end
    end

    def parse_sentence_without_optional_tail
      if look_ahead.is_a?(Parenthesis)
        parse_sentence_in_parenthesis
      else
        return parse_atomic_sentence
        #TODO: Below statement is probably incorrect, add test
        #case to determine intermediate representation.
        # parse_optional_sentence_tail
      end
    end

    def look_ahead
      lexer.look_ahead(0)
    end

    def parse_n_ary_components(previous_operator)
      while look_ahead.is_a?(Operator)
        next_operator = parse_operator
        if previous_operator
          unless previous_operator.string == next_operator.string
            raise ParseError.new("operators in n-ary sentences must be identical")
          end
        end
        parse_sentence_without_optional_tail
      end
    end

    def parse_operator
      operator = lexer.get_next_token
      unless operator.is_a?(Operator)
        raise ParseError.new("Expecting an operator")
      end
      operator
    end

    def parse_sentence_in_parenthesis
      open_parenthesis = lexer.get_next_token
      unless open_parenthesis.is_a?(Parenthesis) &&
        open_parenthesis.string == "("
        raise ParseError.new("Expecting token '('")
      end
      sentence = parse_sentence
      close_parenthesis = lexer.get_next_token
      unless close_parenthesis.is_a?(Parenthesis) &&
        close_parenthesis.string == ")"
        raise ParseError.new("Expecting token ')'")
      end

      return sentence
    end
  end
end
