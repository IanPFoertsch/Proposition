require "pry"
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
        ir_tree = parse_sentence
      end
    end

    def parse_sentence
      current = look_ahead
      if current.is_a?(Parenthesis)
        tree = parse_sentence_in_parenthesis
        tail = parse_optional_sentence_tail
        conjoin_optional_tail(tree, tail)

      elsif current.is_a?(UnaryOperator)
        parse_unary_sentence_with_tail

      else
        tree = parse_atomic_sentence
        tail = parse_optional_sentence_tail
        conjoin_optional_tail(tree, tail)

      end
      #after we parse a sentence, we should assert that the next
      #token is either a new line or some sentence delimiter, such as
      #';', this will solve the issue of asserting that the next token is
      #not a unary, or atomic, or whatever
    end

    def parse_atomic_sentence
      atom = lexer.get_next_token
      unless atom.is_a?(Atom)
        raise ParseError.new("Expecting an atom")
      end

      IRTree.new(atom)
    end

    def parse_unary_sentence_with_tail
      unary_sentence = parse_unary_sentence
      tail = parse_optional_sentence_tail
      conjoin_optional_tail(unary_sentence, tail)
    end

    def conjoin_optional_tail(tree, tail)
      return tree unless tail
      if tree.unary?
        #we have to use left_append here b/c if a unary sentence has
        #a tail, it necessarily is nested within the n_ary_operator
        #present within the tail
        tail.left_append(tree)
      else
        tree.append(tail)
      end
    end

    def parse_unary_sentence
      raise ParseError.new("Cannot begin sentence with non-unary operator") unless look_ahead.is_a?(UnaryOperator)
      operator = parse_operator
      if look_ahead.is_a?(UnaryOperator)
        #we have to recurse here to handle strings of unary operators
        sentence = parse_unary_sentence
      else
        #we don't parse an optional tail b/c the unary operator
        #'binds' to the most proximate sentence.
        sentence = parse_sentence_without_optional_tail
      end
      #cannot construct sentence of a series of unary sentences
      assert_next_not_unary

      IRTree.new(nil, operator, sentence)
    end

    def parse_sentence_without_optional_tail
      if look_ahead.is_a?(Parenthesis)
        parse_sentence_in_parenthesis
      elsif look_ahead.is_a?(UnaryOperator)
        parse_unary_sentence
      else
        parse_atomic_sentence
      end
    end

    def parse_optional_sentence_tail
      #TODO: Refactor this block into smaller chunks
      assert_next_not_unary
      return nil unless look_ahead.is_a?(NAryOperator)

      sentences = []
      previous_operator = nil

      while look_ahead.is_a?(NAryOperator)
        operator = parse_operator

        if previous_operator
          unless previous_operator.string == operator.string
            raise ParseError.new("operators in n-ary sentences must be identical")
          end
        end

        sentences.push(parse_sentence_without_optional_tail)
        previous_operator = operator
      end
      #TODO: Asserting what should come 'after' a particular structure is parsed
      #seems to be bad practice, consolidate these assertions back to the top
      #level, where we can make better assertions about what tokens are expected
      #after parsing a structure
      assert_next_not_unary
      #if we've parsed an operator, return a sentence, otherwise just return
      #the parsed unary sentence
      operator ? IRTree.new(nil, operator, sentences) : sentences.first
    end

    def look_ahead
      lexer.look_ahead(0)
    end

    def parse_operator
      operator = lexer.get_next_token

      unless operator.is_a?(Operator)
        raise ParseError.new("Expecting an operator")
      end
      operator
    end

    def assert_next_not_unary
      if look_ahead.is_a?(UnaryOperator)
        raise ParseError.new("Sentences cannot be concatenated using a unary operator")
      end
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
