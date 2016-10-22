module Proposition
  class Lexer

    L_PARENTHESIS = "("
    R_PARENTHESIS = ")"

    SLASH = "/"
    WHITESPACE = [" ", "\n" "\t"]


    def initialize(input)
      @characters = input.chars #split by whitespace
      @current = 0
    end


    def next_token
      if current_is_character?
        return consume_characters
      elsif current_is_whitespace?
        consume_whitespace
        next_token
      end
    end

    def consume_characters
      identifier = ""
      while current_is_character? || current_is_numeric?
        identifier += consume_current
      end

      identifier
    end

    def current_is_whitespace?
      WHITESPACE.include?(current)
    end

    def consume_whitespace
      while current_is_whitespace?
        @current += 1
      end
    end

    def consume_current
      character = current
      @current += 1

      character
    end

    def identifier?
      character? || numeric?
    end

    def current_is_character?
      #matches any alphanumeric
      result = current =~ /[A-Za-z_]/
    end

    def current_is_numeric?
      current =~ /[0-9]/
    end

    def parenthesis?
      current == "(" || current == ")"
    end

    def current
      @characters[@current]
    end

  end
end
