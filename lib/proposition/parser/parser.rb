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

    def parse_sentence
      current = look_ahead
      if current.is_a?(Parenthesis)
        parse_sentence_in_parenthesis
        parse_optional_sentence_tail

      elsif current.is_a?(UnaryOperator)
        parse_unary_sentence_with_tail
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

    def parse_unary_sentence_with_tail
      unary_sentence = parse_unary_sentence
      tail = parse_optional_sentence_tail
      if tail
        #Need to "left append" the unary sentence into the tail
        #To maintain the order of the inputs
        return tail.left_append(unary_sentence)
      else
        return unary_sentence
      end
    end

    def parse_unary_sentence
      raise ParseError.new("Cannot begin sentence with non-unary operator") unless look_ahead.is_a?(UnaryOperator)
      operator = parse_operator
      if look_ahead.is_a?(UnaryOperator)
        #we have to recurse here to handle strings of unary operators
        sentence = parse_unary_sentence
      else
        sentence = parse_sentence_without_optional_tail
      end
      #cannot construct sentence of a series of unary sentences
      if look_ahead.is_a?(UnaryOperator)
        raise ParseError.new("Sentences cannot be concatenated using a unary operator")
      end
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
      return nil unless look_ahead.is_a?(Operator)

      sentences = []
      previous_operator = nil

      while look_ahead.is_a?(Operator)

        if look_ahead.is_a?(UnaryOperator)
          sentences.push(parse_unary_sentence)
        elsif look_ahead.is_a?(NAryOperator)
          operator = parse_operator

          if previous_operator
            unless previous_operator.string == operator.string
              raise ParseError.new("operators in n-ary sentences must be identical")
            end
          end

          sentences.push(parse_sentence_without_optional_tail)
          previous_operator = operator
        end
      end
      #TODO: refactor this awkward case handling
      return sentences.first unless operator  #return the solo unary sentence
      return IRTree.new(nil, operator, sentences) #otherwise return the parsed sentences connected
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
